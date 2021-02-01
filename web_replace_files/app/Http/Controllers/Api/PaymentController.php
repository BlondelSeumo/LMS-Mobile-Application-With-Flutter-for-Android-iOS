<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Auth;
use App\Course;
use App\Order;
use Validator;
use DB;
use App\BankTransfer;
use App\Currency;
use App\Cart;
use App\Wishlist;
use Mail;
use App\Mail\SendOrderMail;
use App\Notifications\UserEnroll;
use App\User;
use Notification;
use Carbon\Carbon;
use App\InstructorSetting;
use App\PendingPayout;
use App\Coupon;

class PaymentController extends Controller
{
    public function paystore(Request $request){

        $validator = Validator::make($request->all(), [
            'secret' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['Secret Key is required']);
        }

        $key = DB::table('api_keys')->where('secret_key', '=', $request->secret)->first();

        if (!$key) {
            return response()->json(['Invalid Secret Key !']);
        }

        $auth = Auth::user();

        $currency = Currency::first();
            
        $carts = Cart::where('user_id', $auth->id)->get();

        if($file = $request->file('proof'))
        {
            $name = time().$file->getClientOriginalName();
            $file->move('images/order', $name);
            $input['proof'] = $name;
        }
        else{
            $name = null;
        }


        if($request->pay_status == 1) {
           
            foreach($carts as $cart)
            {
                if ($cart->offer_price != 0)
                {
                    $pay_amount =  $cart->offer_price;
                }
                else
                {
                    $pay_amount =  $cart->price;
                }

                if ($cart->disamount != 0 || $cart->disamount != NULL)
                {
                    $cpn_discount =  $cart->disamount;
                }
                else
                {
                    $cpn_discount =  '';
                }


                $lastOrder = Order::orderBy('created_at', 'desc')->first();

                if ( ! $lastOrder )
                {
                    // We get here if there is no order at all
                    // If there is no number set it to 0, which will be 1 at the end.
                    $number = 0;
                }
                else
                { 
                    $number = substr($lastOrder->order_id, 3);
                }

                if($cart->type == 1)
                {
                    $bundle_id = $cart->bundle_id;
                    $bundle_course_id = $cart->bundle->course_id;
                    $course_id = NULL;
                    $duration = NULL;
                    $instructor_payout = 0;
                    $todayDate = NULL;
                    $expireDate = NULL;
                    $instructor_id = $cart->bundle->user_id;
                }
                else{


                    if($cart->courses->duration_type == "m")
                    {
                        
                        if($cart->courses->duration != NULL && $cart->courses->duration !='')
                        {
                            $days = $cart->courses->duration * 30;
                            $todayDate = date('Y-m-d');
                            $expireDate = date("Y-m-d", strtotime("$todayDate +$days days"));
                        }
                        else{
                            $todayDate = NULL;
                            $expireDate = NULL;
                        }
                    }
                    else
                    {

                        if($cart->courses->duration != NULL && $cart->courses->duration !='')
                        {
                            $days = $cart->courses->duration;
                            $todayDate = date('Y-m-d');
                            $expireDate = date("Y-m-d", strtotime("$todayDate +$days days"));
                        }
                        else{
                            $todayDate = NULL;
                            $expireDate = NULL;
                        }

                    }


                    $setting = InstructorSetting::first();

                    if($cart->courses->instructor_revenue != NULL)
                    {
                        $x_amount = $pay_amount * $cart->courses->instructor_revenue;
                        $instructor_payout = $x_amount / 100;
                    }
                    else
                    {

                        if(isset($setting))
                        {
                            if($cart->courses->user->role == "instructor")
                            {
                                $x_amount = $pay_amount * $setting->instructor_revenue;
                                $instructor_payout = $x_amount / 100;
                            }
                            else
                            {
                                $instructor_payout = 0;
                            }
                            
                        }
                        else
                        {
                            $instructor_payout = 0;
                        }  
                    }

                    $bundle_id = NULL;
                    $course_id = $cart->course_id;
                    $bundle_course_id = NULL;
                    $duration = $cart->courses->duration;
                    $instructor_id = $cart->courses->user_id;
                }

                if($request->payment_method == 'paypal')
                {
                    $saleId = $request->sale_id;
                }
                else{

                    $saleId = NULL;
                }

                if($request->payment_method == 'bank_transfer')
                {

                    $transaction_id = str_random(32);
                    $status =  '0';
                    
                }
                else{

                    $transaction_id = $request->transaction_id;
                    $status =  '1';
                    
                }
                    
                $created_order = Order::create([

                    'course_id' => $course_id,
                    'user_id' => $auth->id,
                    'instructor_id' => $instructor_id,
                    'order_id' => '#' . sprintf("%08d", intval($number) + 1),
                    'transaction_id' => $transaction_id,
                    'payment_method' => $request->payment_method,
                    'total_amount' => $pay_amount,
                    'coupon_discount' => $cpn_discount,
                    'currency' => $currency->currency,
                    'currency_icon' => $currency->icon,
                    'duration' => $duration,
                    'enroll_start' => $todayDate,
                    'enroll_expire' => $expireDate,
                    'bundle_id' => $bundle_id,
                    'bundle_course_id' => $bundle_course_id,
                    'sale_id' => $saleId,
                    'status' => $status,
                    'proof' => $name,
                    'created_at'  => \Carbon\Carbon::now()->toDateTimeString(),
                    ]
                );

                Wishlist::where('user_id',$auth->id)->where('course_id', $cart->course_id)->delete();

                Cart::where('user_id',$auth->id)->delete();

                if($instructor_payout != 0)
                {
                    if($created_order)
                    {
                        if($cart->type == 0)
                        {
                            if($cart->courses->user->role == "instructor")
                            {

                                $created_payout = PendingPayout::create([
                                    'user_id' => $cart->courses->user_id,
                                    'course_id' => $cart->course_id,
                                    'order_id' => $created_order->id,
                                    'transaction_id' => $request->transaction_id,
                                    'total_amount' => $pay_amount,
                                    'currency' => $currency->currency,
                                    'currency_icon' => $currency->icon,
                                    'instructor_revenue' => $instructor_payout,
                                    'created_at'  => \Carbon\Carbon::now()->toDateTimeString(),
                                    'updated_at'  => \Carbon\Carbon::now()->toDateTimeString(),
                                    ]
                                );
                            }
                        }
                    }
                }
                

                if($created_order){
                    try{
                        
                        /*sending email*/
                        $x = 'You are successfully enrolled in a course';
                        $order = $created_order;
                        Mail::to(Auth::User()->email)->send(new SendOrderMail($x, $order));


                    }catch(\Swift_TransportException $e){


                        return response()->json(['message' => 'Payment success! but mail not send'], 200);
                    }
                }

                if($cart->type == 0)
                {

                    if($created_order){
                        // Notification when user enroll
                        $cor = Course::where('id', $cart->course_id)->first();

                        $course = [
                          'title' => $cor->title,
                          'image' => $cor->preview_image,
                        ];

                        $enroll = Order::where('course_id', $cart->course_id)->get();

                        if(!$enroll->isEmpty())
                        {
                            foreach($enroll as $enrol)
                            {
                                $user = User::where('id', $enrol->user_id)->get();
                                Notification::send($user,new UserEnroll($course));
                            }
                        }
                    }
                }

                return response()->json('Payment Successfull !', 200);

            } 

        }
        else{

            return response()->json('Payment Failed !', 401);

        }
        
        
        return response()->json('Payment Failed !', 401);
                    
                
              
    }



    public function purchasehistory(Request $request){

        $validator = Validator::make($request->all(), [
            'secret' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['Secret Key is required']);
        }

        $key = DB::table('api_keys')->where('secret_key', '=', $request->secret)->first();

        if (!$key) {
            return response()->json(['Invalid Secret Key !']);
        }

        $user = Auth::user();

        $enroll = Order::where('user_id', $user->id)->where('status', 1)->with('courses')->get();

        return response()->json(array('orderhistory' =>$enroll), 200);      
    }


    public function apikeys(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'secret' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['Secret Key is required']);
        }

        $key = DB::table('api_keys')->where('secret_key', '=', $request->secret)->first();

        if (!$key) {
            return response()->json(['Invalid Secret Key !']);
        }

        
        $stripekey =  env('STRIPE_KEY');
        $stripesecret = env('STRIPE_SECRET');

        $paypal_client_id =  env('PAYPAL_CLIENT_ID');
        $paypal_secret = env('PAYPAL_SECRET');
        $paypal_mode =  env('PAYPAL_MODE');

        $instamojo_api_key =  env('IM_API_KEY');
        $instamojo_auth_token = env('IM_AUTH_TOKEN');
        $instamojo_url =  env('IM_URL');

        $razorpay_key =  env('RAZORPAY_KEY');
        $razorpay_secret = env('RAZORPAY_SECRET');

        $paystack_public_key =  env('PAYSTACK_PUBLIC_KEY');
        $paystack_secret = env('PAYSTACK_SECRET_KEY');
        $paystack_pay_url =  env('PAYSTACK_PAYMENT_URL');
        $paystack_merchant_email =  env('PAYSTACK_MERCHANT_EMAIL');

        $paytm_enviroment = env('PAYTM_ENVIRONMENT');
        $paytm_merchant_id =  env('PAYTM_MERCHANT_ID');
        $paytm_merchant_key =  env('PAYTM_MERCHANT_KEY');
        $paytm_merchant_website = env('PAYTM_MERCHANT_WEBSITE');
        $paytm_channel =  env('PAYTM_CHANNEL');
        $paytm_industry_type =  env('PAYTM_INDUSTRY_TYPE');


        $bank_details = BankTransfer::first();

        
        return response()->json(array(
            'stripekey' => $stripekey, 
            'stripesecret' => $stripesecret, 
            'paypal_client_id' => $paypal_client_id, 
            'paypal_secret' => $paypal_secret, 
            'paypal_mode' => $paypal_mode,
            'instamojo_api_key' => $instamojo_api_key,
            'instamojo_auth_token' => $instamojo_auth_token,
            'instamojo_url' => $instamojo_url,
            'razorpay_key' => $razorpay_key,
            'razorpay_secret' => $razorpay_secret,
            'paystack_public_key' => $paystack_public_key,
            'paystack_secret' => $paystack_secret,
            'paystack_pay_url' => $paystack_pay_url,
            'paystack_merchant_email' => $paystack_merchant_email,
            'paytm_enviroment' => $paytm_enviroment,
            'paytm_merchant_id' => $paytm_merchant_id,
            'paytm_merchant_key' => $paytm_merchant_key,
            'paytm_merchant_website' => $paytm_merchant_website,
            'paytm_channel' => $paytm_channel,
            'paytm_industry_type' => $paytm_industry_type,
            'bank_details' => $bank_details,
              ), 200);
        
        
        
    }



}
