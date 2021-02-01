<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Coupon;
use Carbon;
use App\Cart;
use Auth;
use Session;
use DB;
use Validator;

class CouponController extends Controller
{
    public function applycoupon(Request $request)
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

        $auth = Auth::user();

        $coupon = Coupon::where('code', $request->coupon)->first();
        $mytime = Carbon\Carbon::now();
        $date = $mytime->toDateTimeString();

        if(isset($coupon)){

            if($coupon->expirydate >= $date)
            {
                if($coupon->maxusage != 0)
                {
                    if($coupon->link_by == 'course')
                    {

                        $course_coupon = $this->validCouponForCourse($coupon, $auth);

                        return $course_coupon;

                    }
                    elseif($coupon->link_by == 'cart')
                    {

                        $cart_coupon = $this->validCouponForCart($coupon, $auth);

                        return $cart_coupon;

                    }
                    elseif($coupon->link_by == 'category')
                    {

                        $category_coupon = $this->validCouponForCategory($coupon, $auth);

                        return $category_coupon;

                    }
                }
                else
                {
                    return response()->json('Coupon max limit reached !', 401);
                }

            }
            else
            {
                return response()->json('Coupon Expired !', 401);
            }

        }else{

            return response()->json('Invalid Coupon !', 401);
        }

    }

    public function validCouponForCourse($coupon, $auth)
    {

        $cart = Cart::where('course_id', '=', $coupon['course_id'])->where('user_id', '=', $auth->id)->first();

        $carts = Cart::where('user_id', '=', $auth->id)
            ->get();
        $per = 0;

        if (isset($cart))
        {
            if ($cart->course_id == $coupon->course_id)
            {

                if ($coupon->distype == 'per')
                {
                    $per = $cart->offer_price * $coupon->amount / 100;
                }
                else
                {
                    $per = $coupon->amount;
                }

                

                // Putting a session//
                // Session::put('coupanapplied', ['code' => $coupon->code, 'cpnid' => $coupon->id, 'discount' => $per, 'msg' => "$coupon->code is applied !", 'appliedOn' => 'course']);

                Cart::where('course_id', '=', $coupon['course_id'])->where('user_id', '=', $auth
                    ->id)
                    ->update(['distype' => 'course', 'disamount' => $per]);
                Cart::where('course_id', '!=', $coupon['course_id'])->where('user_id', '=', $auth
                    ->id)
                    ->update(['distype' => NULL, 'disamount' => NULL]);

                DB::table('coupons')->where('code', '=', $coupon['code'])->decrement('maxusage', 1);

                return response()->json(['discount_amount' => $per, 'msg' => 'Coupon Applied !']);

            }
            else
            {
                
                return response()->json('Sorry no product found in your cart for this coupon !', 401);
            }
        }
        else
        {

            return response()->json('Sorry no product found in your cart for this coupon  !', 401);
        }
    }

    public function validCouponForCart($coupon, $auth)
    {
        $cart = Cart::where('user_id', '=', $auth->id)->get();

        $total = 0;

        if (isset($cart))
        {

            foreach ($cart as $key => $c)
            {
                if ($c->offer_price != 0)
                {
                    $total = $total + $c->offer_price;
                }
                else
                {
                    $total = $total + $c->price;
                }
            }
            if ($coupon->minamount != 0)
            {

                if ($total >= $coupon->minamount)
                {
                    //check cart amount 
                    $totaldiscount = 0;
                    $per = 0;

                    foreach ($cart as $key => $c)
                    {

                        if ($coupon->distype == 'per')
                        {

                            if ($c->offer_price != 0)
                            {
                                $per = $c->offer_price * $coupon->amount / 100;
                                $totaldiscount = $totaldiscount + $per;
                            }
                            else
                            {
                                $per = $c->price * $coupon->amount / 100;
                                $totaldiscount = $totaldiscount + $per;
                            }

                        }
                        else
                        {

                            if ($c->offer_price != 0)
                            {
                                $per = $coupon->amount / count($cart);
                                $totaldiscount = $totaldiscount + $per;
                            }
                            else
                            {
                                $per = $coupon->amount / count($cart);
                                $totaldiscount = $totaldiscount + $per;
                            }

                        }
                        // return $per;

                        Cart::where('id', '=', $c->id)
                            ->update(['distype' => 'cart', 'disamount' => $per]);

                    }

                    //Putting a session//
                    //Session::put('coupanapplied', ['code' => $coupon->code, 'cpnid' => $coupon->id, 'discount' => $totaldiscount, 'msg' => "$coupon->code Applied Successfully !", 'appliedOn' => 'cart']);

                    DB::table('coupons')->where('code', '=', $coupon['code'])->decrement('maxusage', 1);

                    return response()->json(['discount_amount' => $totaldiscount, 'msg' => 'Coupon Applied !']);

                    
                }
                else
                {
                    
                    return response()->json('Failed !', 401);
                }

            }
            else
            {

                //check cart amount 
                $totaldiscount = 0;
                $per = 0;

                foreach ($cart as $key => $c)
                {

                    if ($coupon->distype == 'per')
                    {

                        if ($c->offer_price != 0)
                        {
                            $per = $c->offer_price * $coupon->amount / 100;
                            $totaldiscount = $totaldiscount + $per;
                        }
                        else
                        {
                            $per = $c->price * $coupon->amount / 100;
                            $totaldiscount = $totaldiscount + $per;
                        }

                    }
                    else
                    {

                        if ($c->offer_price != 0)
                        {
                            $per = $coupon->amount / count($cart);
                            $totaldiscount = $totaldiscount + $per;
                        }
                        else
                        {
                            $per = $coupon->amount / count($cart);
                            $totaldiscount = $totaldiscount + $per;
                        }

                    }

                    Cart::where('id', '=', $c->id)
                        ->update(['distype' => 'cart', 'disamount' => $per]);

                }

                //Putting a session//
                // Session::put('coupanapplied', ['code' => $coupon->code, 'cpnid' => $coupon->id, 'discount' => $totaldiscount, 'msg' => "$coupon->code Applied Successfully !", 'appliedOn' => 'cart']);

                DB::table('coupons')->where('code', '=', $coupon['code'])->decrement('maxusage', 1);

                return response()->json(['discount_amount' => $totaldiscount, 'msg' => 'Coupon Applied !']);

                //end return success with discounted amount

            }

        }
    }

    public function validCouponForCategory($coupon, $auth)
    {
        
        $cart = Cart::where('user_id', '=', $auth->id)
        ->get();
        $catcart = collect();

        foreach ($cart as $row)
        {

            if ($row
                ->courses
                ->category->id == $coupon->category_id)
            {
                $catcart->push($row);

            }

        }

        if (count($catcart) > 0)
        {

            $total = 0;
            $totaldiscount = 0;
            $distotal = 0;

            foreach ($catcart as $key => $row)
            {
                if ($row->offer_price != 0)
                {
                    $total = $total + $row->offer_price;
                }
                else
                {
                    $total = $total + $row->price;
                }
            }



            foreach ($catcart as $key => $c)
            {

                $per = 0;

                if ($coupon->distype == 'per')
                {

                    if ($c->offer_price != 0)
                    {

                        $per = $c->offer_price * $coupon->amount / 100;
                        $totaldiscount = $totaldiscount + $per;

                    }
                    else
                    {
                        $per = $c->price * $coupon->amount / 100;
                        $totaldiscount = $totaldiscount + $per;
                    }

                }
                else
                {

                    if ($c->offer_price != 0)
                    {
                        $per = $coupon->amount / count($catcart);
                        $totaldiscount = $totaldiscount + $per;
                    }
                    else
                    {
                        $per = $coupon->amount / count($catcart);
                        $totaldiscount = $totaldiscount + $per;
                    }

                }

                Cart::where('id', '=', $c->id)
                    ->where('user_id', $auth
                    ->id)
                    ->update(['distype' => 'category', 'disamount' => $per]);

                Cart::where('category_id', '!=', $c->courses->category['id'])->where('user_id', '=', $auth
                    ->id)
                    ->update(['distype' => NULL, 'disamount' => NULL]);

                
            }


            if ($coupon->minamount != 0)
            {

                if ($total >= $coupon->minamount)
                {

                    //Putting a session//
                    // Session::put('coupanapplied', ['code' => $coupon->code, 'cpnid' => $coupon->id, 'discount' => $totaldiscount, 'msg' => "$coupon->code Applied Successfully !", 'appliedOn' => 'category']);

                     DB::table('coupons')->where('code', '=', $coupon['code'])->decrement('maxusage', 1);

                    return response()->json(['discount_amount' => $totaldiscount, 'msg' => 'Coupon Applied !']);

                }
                else
                {
                    Cart::where('user_id', $auth
                        ->id)
                        ->update(['distype' => NULL, 'disamount' => NULL]);
                    

                    return response()->json('Failed !', 401);
                }

            }
            else
            {
                //Putting a session//
                // Session::put('coupanapplied', ['code' => $coupon->code, 'cpnid' => $coupon->id, 'discount' => $totaldiscount, 'msg' => "$coupon->code Applied Successfully !", 'appliedOn' => 'category']);

                DB::table('coupons')->where('code', '=', $coupon['code'])->decrement('maxusage', 1);

                return response()->json(['discount_amount' => $totaldiscount, 'msg' => 'Coupon Applied !']);
            }

        }
        else
        {
            return response()->json('Sorry no matching product found in your cart for this coupon !', 401);
        }

        
    }


    public function remove(Request $request)
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

        $user = Auth::user();

        // Session::forget('coupanapplied');
        
        Cart::where('user_id', '=', $auth->id)
            ->update(['distype' => NULL, 'disamount' => NULL]);
        

        return response()->json('Coupon Removed !', 200);
       
    }
}
