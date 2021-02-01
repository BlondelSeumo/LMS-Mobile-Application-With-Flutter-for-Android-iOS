<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Laravel\Passport\Client;
use App\Setting;
use Illuminate\Support\Carbon;
use Mail;
use Illuminate\Support\Str;
use App\Mail\verifyEmail;
use App\Mail\WelcomeUser;

class RegisterController extends Controller
{
    use IssueTokenTrait;

	private $client;

	public function __construct(){
		$this->client = Client::find(2);
	}

    public function register(Request $request){

    	$this->validate($request, [
    		'name' => 'required',
    		'email' => 'required|email|unique:users,email',
    		'password' => 'required|min:6'
    	]);

        $setting = Setting::first();

        if($setting->verify_enable == 0)
        {
            $verified = \Carbon\Carbon::now()->toDateTimeString();
        }
        else
        {
            $verified = NULL;
        }

    	$user = User::create([
    		'fname' => request('name'),
    		'email' => request('email'),
            'email_verified_at'  => $verified,
    		'password' => bcrypt(request('password')),

    	]);

        $config = Setting::first();
       

        if($config->w_email_enable == 1){
          try{
                Mail::to(request('email'))->send(new WelcomeUser($user));
            }
            catch(\Swift_TransportException $e){
                return response()->json('Registration done. Mail Sending Error', 200);
            }
        }

        if($config->verify_enable == 0)
        {
            return $this->issueToken($request, 'password');  
        }
        else
        {
            if($user->email_verified_at != NULL)
            {
                return $this->issueToken($request, 'password');  
            }
            else
            {
                return response()->json('Verify your email', 402); 
            }
            
        }
        
    }

   

    public function verifyemail(Request $request){
        $user = User::where(['email' => $request->email, 'verifyToken' => $request->token])->first();
        if($user){
            $user->status=1; 
            $user->verifyToken=NULL;
            $user->save();
            Mail::to($user->email)->send(new WelcomeUser($user));
            return $this->issueToken($request, 'password');
        }else{
            return response()->json('user not found', 401);
        }
    }

}
