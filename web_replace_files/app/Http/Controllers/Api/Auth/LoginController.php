<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;  
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;
use Laravel\Passport\Client;
use Laravel\Passport\HasApiTokens;
use App\User;
use App\Setting;
use Mail;
use Validator;
use Hash;

class LoginController extends Controller
{

    use IssueTokenTrait;

	private $client;

	public function __construct(){
		$this->client = Client::find(2);
	}

    public function login(Request $request)
    {

    	$this->validate($request, [
    		'email' => 'required',
    		'password' => 'required'
    	]);
        
        $authUser = User::where('email', $request->email)->first();
        if(isset($authUser) && $authUser->status == 0){
            return response()->json('Blocked User', 401); 
        }
        else{

            $setting = Setting::first();

            if(isset($authUser))
            {
                if($setting->verify_enable == 0)
                {
                    return $this->issueToken($request, 'password');  
                }
                else
                {
                    if($authUser->email_verified_at != NULL)
                    {
                        return $this->issueToken($request, 'password');  
                    }
                    else
                    {
                        return response()->json('Verify your email', 402); 
                    }
                }

            }
            else{

                return response()->json('invalid User login', 401);

            }

            
            
        }

    }

    public function fblogin(Request $request){

        $this->validate($request, [
            'email' => 'required',
            'name' => 'required',
            'code' => 'required',
            'password' => ''
        ]);
        $authUser = User::where('email', $request->email)->first();
        if($authUser){
            $authUser->facebook_id = $request->code;
            $authUser->fname = $request->name;
            $authUser->save();
            if(isset($authUser) &&  $authUser->status == '0'){
                return response()->json('Blocked User', 401); 
            }
             else{
                   if (Hash::check('password', $authUser->password)) {

                        return $response = $this->issueToken($request,'password');

                } else {
                    $response = ["message" => "Password mismatch"];
                    return response($response, 422);
                }

            }
        }
        else{

            $verified = \Carbon\Carbon::now()->toDateTimeString();

            $user = User::create([
                'fname' =>  request('name'),
                'email' => request('email'),
                'password' => Hash::make($request->password !='' ? $request->password : 'password'),
                'facebook_id' => request('code'),
                'status'=>'1',
                'email_verified_at'  => $verified
            ]);
            
            return $this->issueToken($request, 'password');
        }
    }

    public function googlelogin(Request $request){


        $this->validate($request, [
            'email' => 'required',
            'name' => 'required',
            'uid' => 'required',
            'password' => ''
        ]);

        $authUser = User::where('email', $request->email)->first();

        if($authUser){

            $authUser->google_id = $request->uid;
            $authUser->fname = $request->name;
            $authUser->save();

            if(isset($authUser) &&  $authUser->status == '0'){
                return response()->json('Blocked User', 401); 
            }

            else{

                if (Hash::check('password', $authUser->password)) {

                    return $response = $this->issueToken($request,'password');

                } else {
                    $response = ["message" => "Password mismatch"];
                    return response($response, 422);
                }

            }
        }
        else{


            $verified = \Carbon\Carbon::now()->toDateTimeString();

            $user = User::create([
                'fname' =>  request('name'),
                'email' => request('email'),
                'password' => Hash::make($request->password !='' ? $request->password : 'password'),
                'google_id' => request('uid'),
                'status'=>'1',
                'email_verified_at'  => $verified
            ]);
           
            return $response = $this->issueToken($request, 'password');
                
            
        }
    }



    public function refresh(Request $request){
    	$this->validate($request, [
    		'refresh_token' => 'required'
    	]);

    	return $this->issueToken($request, 'refresh_token');
    }
    
    public function forgotApi(Request $request)
    { 
        $user = User::whereEmail($request->email)->first();
        if($user){

            $uni_col = array(User::pluck('code'));
            do {
              $code = str_random(5);
            } while (in_array($code, $uni_col));            
            try{
                $config = Setting::findOrFail(1);
                $logo = $config->logo;
                $email = $config->wel_email;
                $company = $config->project_title;
                Mail::send('forgotemail', ['code' => $code, 'logo' => $logo, 'company'=>$company], function($message) use ($user, $email) {
                    $message->from($email)->to($user->email)->subject('Reset Password Code');
                });
                $user->code = $code;
                $user->save();
                return response()->json('ok', 200);
            }
            catch(\Swift_TransportException $e){
                return response()->json('Mail Sending Error', 400);
            }
        }
        else{          
            return response()->json('user not found', 401);  
        }
    }

    public function verifyApi(Request $request)
    { 
        if( ! $request->code || ! $request->email)
        {
            return response()->json('email and code required', 449);
        }

        $user = User::whereEmail($request->email)->whereCode($request->code)->first();

        if( ! $user)
        {            
            return response()->json('not found', 401);
        }
        else{
            $user->code = null;
            $user->save();
            return response()->json('ok', 200);
        }
    }

    public function resetApi(Request $request)
    { 

        $validator = Validator::make($request->all(), [
            'password' => 'required|confirmed|min:6',
        ]);

        $user = User::whereEmail($request->email)->first();

        if($user){

            $user->update(['password' => bcrypt($request->password)]);

            $user->save(); 
            
            return response()->json('ok', 200);
        }
        else{          
            return response()->json('not found', 401);
        }
    }

    public function logoutApi()
    {

        $token = Auth::user()->token();
        $token->revoke();
        $response = ['message' => 'You have been successfully logged out!'];
        return response($response, 200);

    }
    
}
