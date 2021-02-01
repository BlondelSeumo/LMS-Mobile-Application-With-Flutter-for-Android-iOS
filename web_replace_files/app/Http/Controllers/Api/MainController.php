<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\User;
use App\Categories;
use App\SubCategory;
use App\ChildCategory;
use App\Slider;
use App\CategorySlider;
use Illuminate\Support\Carbon;
use App\Course;
use App\Order;
use App\Wishlist;
use DB;
use App\BundleCourse;
use App\Testimonial;
use App\Trusted;
use App\FaqStudent;
use App\FaqInstructor;
use App\Blog;
use Validator;
use Hash;
use App\Cart;
use App\Setting;
use App\Page;
use App\Adsense;
use App\SliderFacts;
use App\ReviewRating;
use App\CourseChapter;
use App\CourseClass;
use App\Coupon;
use App\About;
use App\Contact;
use App\Instructor;
use App\CourseProgress;
use App\Terms;
use App\Career;
use App\Meeting;
use App\BBL;
use App\Currency;
use App\CourseReport;
use App\Announcement;
use App\Assignment;
use App\Question;
use App\Appointment;
use Illuminate\Support\Str;
use App\Answer;
use PDF;
use Mail;
use App\Mail\UserAppointment;


class MainController extends Controller
{

    public function home(Request $request){

        $validator = Validator::make($request->all(), [
            'secret' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['Secret Key is required'], 402);
        }

        $key = DB::table('api_keys')->where('secret_key', '=', $request->secret)->first();

        if (!$key) {
            return response()->json(['Invalid Secret Key !'], 400);
        }

        $settings = Setting::findOrFail(1);
        $adsense = Adsense::first();
        $currency = Currency::first();

        $slider = Slider::all()->toArray();
        $sliderfacts = SliderFacts::all()->toArray();
        $trusted = Trusted::where('status', 1)->get();

        $testimonials = Testimonial::where('status', 1)->get();

        $testimonial_result = array();

        foreach ($testimonials as $testimonial) {

            $testimonial_result[] = array(
                'id' => $testimonial->id,
                'client_name' => $testimonial->client_name,
                'details' => strip_tags($testimonial->details),
                'status' => $testimonial->status,
                'image' => $testimonial->image,
                'imagepath' =>  url('images/testimonial/'.$testimonial->image),
                'created_at' => $testimonial->created_at,
                'updated_at' => $testimonial->created_at,
            );
        }

        $category = Categories::where('status', 1)->orderBy('position', 'asc')->get();

        $subcategory = SubCategory::where('status', 1)->get();
        $childcategory = ChildCategory::where('status', 1)->get();

        $featured_cate = Categories::where('status', 1)->where('featured', 1)->get();

        $meeting = Meeting::get();

        return response()->json(array('settings'=>$settings, 'adsense' => $adsense, 'currency' => $currency, 'slider'=>$slider, 'sliderfacts'=>$sliderfacts, 'trusted'=>$trusted, 'testimonial'=>$testimonial_result, 'category'=>$category, 'subcategory'=>$subcategory, 'childcategory'=>$childcategory, 'featured_cate'=>$featured_cate, 'meeting'=>$meeting ), 200); 
    }

    

    public function main(){
        return response()->json(array('ok'), 200);
    }

    public function course(Request $request){

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

        $course = Course::where('status', 1)->with('include')->with('whatlearns')->with('review')->get();

        return response()->json(array('course'=>$course), 200);       
    }

    public function recentcourse(Request $request){

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

        $course = Course::where('status', 1)->orderBy('id','DESC')->with('include')->with('whatlearns')->get();
        return response()->json(array('course'=>$course), 200);       
    }

    public function featuredcourse(Request $request){

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

        $featured = Course::where('status', 1)->where('featured', 1)->with('include')->with('whatlearns')->with('review')->get();
        return response()->json(array('featured'=>$featured), 200);       
    }

    

    public function bundle(Request $request)
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

        $bundles = BundleCourse::where('status', 1)->get();

        $result = array();

        foreach ($bundles as $bundle) {

            $result[] = array(
                'id' => $bundle->id,
                'user' => $bundle->user->fname,
                'course_id' => $bundle->course_id,
                'title' => $bundle->title,
                'detail' => strip_tags($bundle->detail),
                'price' => $bundle->price,
                'discount_price' => $bundle->discount_price,
                'type' => $bundle->type,
                'slug' => $bundle->slug,
                'status' => $bundle->status,
                'featured' => $bundle->featured,
                'preview_image' => $bundle->preview_image,
                'imagepath' =>  url('images/bundle/'.$bundle->preview_image),
                'created_at' => $bundle->created_at,
                'updated_at' => $bundle->updated_at,
            );
        }

        if (empty($result)) {
            return response()->json(array('bundle'=>$result), 200);
        }

        return response()->json(array('bundle'=>$result), 200);
    }
    

    public function studentfaq(Request $request)
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
        
        $faq = FaqStudent::where('status', 1)->get();
        return response()->json(array('faq'=>$faq), 200);
    }

    public function instructorfaq(Request $request)
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
        
        $faq = FaqInstructor::where('status', 1)->get();
        return response()->json(array('faq'=>$faq), 200);
    }

    public function blog(Request $request)
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
        
        $blog = Blog::where('status', 1)->get();
        return response()->json(array('blog'=>$blog), 200);
    }

    public function blogdetail(Request $request)
    {
        $this->validate($request, [
            'blog_id' => 'required',
        ]);

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
        
        $blog = Blog::where('id', $request->blog_id)->where('status', 1)->get();

        return response()->json(array('blog'=>$blog), 200);
    }

    public function recentblog(Request $request)
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
        
        $blog = Blog::where('status', 1)->orderBy('id','DESC')->get();

        return response()->json(array('blog'=>$blog), 200);
    }

    
    public function showwishlist(Request $request)
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
        
        $wishlist = Wishlist::where('user_id',$user->id)->with('courses')->get();
        
        return response()->json(array('wishlist' =>$wishlist), 200);

        

    }

    public function addtowishlist(Request $request)
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

        $orders = Order::where('user_id', $auth->id)->where('course_id', $request->course_id)->first();


        $wishlist = Wishlist::where('course_id', $request->course_id)->where('user_id', $auth->id)->first();

        if(isset($orders)){

            return response()->json('You Already purchased this course !', 401);
        }
        else{


            if(!empty($wishlist)){
                
                return response()->json('Course is already in wishlist !', 401);
            }
            else{

                $wishlist = Wishlist::create([

                    'course_id' => $request->course_id,
                    'user_id'   => $auth->id,
                ]);

                return response()->json('Course is added to your wishlist !', 200);
            }
            
        }
        
        
    }

    public function removewishlist(Request $request)
    {
        $this->validate($request, [
            'course_id' => 'required',
        ]);

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

        $wishlist = Wishlist::where('course_id', $request->course_id)->where('user_id', $auth->id)->delete();
        
        if($wishlist == 1){
          return response()->json(array('1'), 200); 
        }
        else{
          return response()->json(array('error'), 401);       
        }
    }

    

    public function userprofile(Request $request) 
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
        $code = $user->token();
        return response()->json(array('user' =>$user, 'code'=>$code->id), 200); 
    } 

    

    public function updateprofile(Request $request) 
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

        $request->validate([
          'email' => 'required',
          'current_password' => 'required',
        ]);
        $input = $request->all();

        if (Hash::check($request->current_password, $auth->password)){
          if ($file = $request->file('user_img')) {
            if ($auth->user_img != null) {      
              $image_file = @file_get_contents(public_path().'/images/user_img/'.$auth->user_img);
              if($image_file){            
                unlink(public_path().'/images/user_img/'.$auth->user_img);
              }
            }
            $name = time().$file->getClientOriginalName();
            $file->move('images/user_img', $name);
            $input['user_img'] = $name;
          }
          $auth->update([        
            'fname' => isset($input['fname']) ? $input['fname'] : $auth->fname,
            'lname' => isset($input['lname']) ? $input['lname'] : $auth->lname,
            'email' => $input['email'],
            'password' => isset($input['password']) ? bcrypt($input['password']) : $auth->password,
            'mobile' => isset($input['mobile']) ? $input['mobile'] : $auth->mobile,
            'dob' => isset($input['dob']) ? $input['dob'] : $auth->dob,
            'user_img' =>  isset($input['user_img']) ? $input['user_img'] : $auth->user_img,
            'address' =>  isset($input['address']) ? $input['address'] : $auth->address,
            'detail' =>  isset($input['detail']) ? $input['detail'] : $auth->detail,
          ]);
          
          $auth->save();
          return response()->json(array('auth' =>$auth), 200);
        } 
        else {
          return response()->json('error: password doesnt match', 400);
        }

        
    } 

    public function mycourses(Request $request) 
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

        $enroll = Order::where('user_id', $user->id)->where('status', 1)->get();

        $enroll_details = array();

        if(isset($enroll)){
        
            foreach ($enroll as $enrol) {
                $course = Course::where('id', $enrol->course_id)->with('whatlearns')->with('include')->with('progress')->first();

                $enroll_details[] = array(
                    'title' => isset($course->title) ? $course->title : null,
                    'enroll' => $enrol,
                    'course' => $course

                );

            }
            return response()->json(array('enroll_details' =>$enroll_details), 200);
        }

        return response()->json(array('enroll_details' =>$enroll_details), 200);

         
    } 


    public function addtocart(Request $request)
    {
        $this->validate($request, [
            'course_id' => 'required',
        ]);

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

        $courses = Course::where('id', $request->course_id)->first();

        $orders = Order::where('user_id', $auth->id)->where('course_id', $request->course_id)->first();
        $cart = Cart::where('course_id', $request->course_id)->where('user_id', $auth->id)->first();

        if(isset($courses))
        {
            if($courses->type == 1)
            {
                if(isset($orders))
                {
                    return response()->json('You Already purchased this course !', 401);
                }
                else{

                    if(!empty($cart))
                    {
                        return response()->json('Course is already in cart !', 401);
                    }
                    else
                    {
                        $cart = Cart::create([

                            'course_id' => $request->course_id,
                            'user_id'   => $auth->id,
                            'category_id' => $courses->category_id,
                            'price' => $courses->price,
                            'offer_price' => $courses->discount_price
                        ]);

                        return response()->json('Course is added to your cart !', 200);
                    }
                }
            }
            else{
                return response()->json('Course is free', 401);
            }
        }
        else{
            return response()->json('Invalid Course ID', 401);
        }
        
        
    }


    public function removecart(Request $request)
    {
        $this->validate($request, [
            'course_id' => 'required',
        ]);

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

        $cart = Cart::where('course_id', $request->course_id)->where('user_id', $auth->id)->delete();
        
        if($cart == 1){
          return response()->json(array('1'), 200); 
        }
        else{
          return response()->json(array('error'), 401);       
        }
    }


    public function showcart(Request $request)
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
        
        $cart = Cart::where('user_id',$user->id)->with('courses')->get();
        
        return response()->json(array('cart' =>$cart), 200);

        

    }

    public function removeallcart(Request $request)
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

        $cart = Cart::where('user_id', $auth->id)->delete();
        
        if(isset($cart)){
          return response()->json(array('1'), 200); 
        }
        else{
          return response()->json(array('error'), 401);       
        }
    }


    public function addbundletocart(Request $request)
    {

        $this->validate($request, [
            'bundle_id' => 'required',
        ]);

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

        $bundle_course = BundleCourse::where('id', $request->bundle_id)->first();

        $orders = Order::where('user_id', $auth->id)->where('bundle_id', $request->bundle_id)->first();


        $cart = Cart::where('bundle_id', $request->bundle_id)->where('user_id', $auth->id)->first();

        if(isset($bundle_course))
        {
            if($bundle_course->type == 1)
            {
                if(isset($orders)){

                    return response()->json('You Already purchased this course !', 401);
                }
                else{


                    if(!empty($cart)){
                        
                        return response()->json('Bundle Course is already in cart !', 401);
                    }
                    else{

                        $cart = Cart::create([

                            'bundle_id' => $request->bundle_id,
                            'user_id'   => $auth->id,
                            'type' => '1',
                            'price' => $bundle_course->price,
                            'offer_price' => $bundle_course->discount_price,
                            'created_at'  => \Carbon\Carbon::now()->toDateTimeString(),
                            'updated_at'  => \Carbon\Carbon::now()->toDateTimeString(),
                        ]);

                        return response()->json('Bundle Course is added to your cart !', 200);
                    }
                    
                }
            }
            else{
                return response()->json('Bundle course is free !', 401);
            }
            
        }
        else
        {
            return response()->json('Invalid Bundle Course ID !', 401);
        }

        
        
        
    }

    public function removebundlecart(Request $request)
    {
        $this->validate($request, [
            'bundle_id' => 'required',
        ]);

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

        $cart = Cart::where('bundle_id', $request->bundle_id)->where('user_id', $auth->id)->delete();
        
        if($cart == 1){
          return response()->json(array('1'), 200); 
        }
        else{
          return response()->json(array('error'), 401);       
        }
    }

    public function detailpage(Request $request)
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

        $result = Course::where('id','=',$request->course_id)->where('status', 1)->with('include')->with('whatlearns')->with('related')->with('language')->with('user')->with('order')->with('chapter')->with('courseclass')->first();

        if(!$result){
            return response()->json('404 | Course not found !');
        }


        if(isset($result->review)){

        foreach ($result->review as $key => $review) {
            $reviews[] = [

                'user_id' => $review->user_id,
                'fname' => $review->user->fname,
                'lname' =>  $review->user->lname,
                'userimage' => $review->user->user_img,
                'imagepath' =>  url('images/user_img/'),
                'learn' => $review->learn,
                'price' => $review->price,
                'value' => $review->value,
                'reviews' => $review->review,
                'created_by' => $review->created_at,
                'updated_by' => $review->updated_at,
                
            ];
        }

        }
        

        return response()->json([
            'course' => $result->makeHidden(['review']),
            'review' => isset($reviews) ? $reviews : null
        ]);       
    }


    public function pages(Request $request)
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

        $pages = Page::get();

        return response()->json(array('pages'=>$pages), 200);
    }


    
    


    public function allnotification(Request $request)
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
        $notifications = $user->unreadnotifications;

        if($notifications){
            return response()->json(array('notifications' => $notifications), 200);
        }else {
            return response()->json(array('error'), 401);
        }
    }


    public function notificationread(Request $request, $id)
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

        $userunreadnotification=Auth::user()->unreadNotifications->where('id',$id)->first();
         
        if ($userunreadnotification) {
           $userunreadnotification->markAsRead();
            return response()->json(array('1'), 200);
        }
        else{
            return response()->json(array('error'), 401);            
        }
    }


    public function readallnotification(Request $request)
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

        $notifications = Auth()->User()->notifications()->delete();

         
        if($notifications) {
          
            return response()->json(array('1'), 200);
        }
        else{
            return response()->json(array('error'), 401);            
        }
    }


    public function instructorprofile(Request $request)
    {
        $this->validate($request, [
            'instructor_id' => 'required',
        ]);

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

        $user = User::where('id', $request->instructor_id)->first();
        $course_count = Course::where('user_id', $user->id)->count();
        $enrolled_user = Order::where('instructor_id', $user->id)->count();
        $course = Course::where('user_id', $user->id)->get();
         
        if($user) {
          
            return response()->json(array('user'=>$user, 'course'=>$course, 'course_count'=>$course_count, 'enrolled_user'=>$enrolled_user ), 200);
        }
        else{
            return response()->json(array('error'), 401);            
        }
    }


    public function review(Request $request)
    {
        $this->validate($request, [
            'course_id' => 'required',
        ]);

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

        $review = ReviewRating::where('course_id', $request->course_id)->with('user')->get();

        $review_count = ReviewRating::where('course_id', $request->course_id)->count();
         
        if($review) {
          
            return response()->json(array('review'=>$review ), 200);
        }
        else{
            return response()->json(array('error'), 401);            
        }
    }


    public function duration(Request $request)
    {
        $this->validate($request, [
            'chapter_id' => 'required',
        ]);

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

        $chapter = CourseChapter::where('course_id', $request->chapter_id)->first();

        if($chapter) {
        
            $duration =  CourseClass::where('coursechapter_id', $chapter->id)->sum("duration");
        }
        else{
            return response()->json(['Invalid Chapter ID !'], 401);
        }
         
        if($chapter) {
          
            return response()->json(array( 'duration'=>$duration ), 200);
        }
        else{
            return response()->json(array('error'), 401);            
        }
    }




    public function apikeys(Request $request)
    {

        $key = DB::table('api_keys')->first();

        if (!$key) {
            return response()->json(['Invalid Secret Key !']);
        }

        return response()->json(array('key'=>$key ), 200); 
    }


    public function coursedetail(Request $request){


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

        $course = Course::where('status', 1)->with('include')->with('whatlearns')->with('related')->with('review')->with('language')->with('user')->with('order')->with('chapter')->with('courseclass')->get();

        return response()->json(array('course'=>$course), 200);  



        
    }


    public function showcoupon(Request $request){

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

        $coupon = Coupon::get();

        return response()->json(array('coupon'=>$coupon), 200);       
    }


    public function becomeaninstructor(Request $request)
    {

        $this->validate($request, [
            'fname' => 'required',
            'lname' => 'required',
            'email' => 'required',
            'dob' => 'required',
            'mobile' => 'required',
            'gender' => 'required',
            'detail' => 'required',
            'file' => 'required',
            'image' => 'required',
        ]);

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

        $users = Instructor::where('user_id', $auth->id)->get();

        if(!$users->isEmpty()){

            return response()->json('Already Requested !', 401);  
        }
        else{

            if ($file = $request->file('image'))
            {
                $name = time().$file->getClientOriginalName();
                $file->move('images/instructor', $name);
                $input['image'] = $name;
            }


            if($file = $request->file('file'))
            {
                $name = time().$file->getClientOriginalName();
                $file->move('files/instructor/',$name);
                $input['file'] = $name;
            }

            $input = $request->all();

            $instructor = Instructor::create([
                'user_id' => $auth->id,    
                'fname' => isset($input['fname']) ? $input['fname'] : $auth->fname,
                'lname' => isset($input['lname']) ? $input['lname'] : $auth->lname,
                'email' => $input['email'],
                'mobile' => isset($input['mobile']) ? $input['mobile'] : $auth->mobile,
                'dob' => isset($input['dob']) ? $input['dob'] : $auth->dob,
                'image' =>  isset($input['image']) ? $input['image'] : $auth->image,
                'file' =>  $input['file'],
                'detail' =>  isset($input['detail']) ? $input['detail'] : $auth->detail,
                'gender' =>  isset($input['gender']) ? $input['gender'] : $auth->gender,
                'status' => '0',
            ]);

            return response()->json(array('instructor'=>$instructor), 200);
        }

               
    }


    public function aboutus(Request $request)
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

        $about = About::all()->toArray();
        return response()->json(array('about'=>$about), 200);
    }


    public function contactus(Request $request)
    {

        $this->validate($request, [
            'fname' => 'required',
            'email' => 'required',
            'mobile' => 'required',
            'message' => 'required',
        ]);

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


        $created_contact = Contact::create([
            'fname' => $request->fname,
            'email' => $request->email,
            'mobile' => $request->mobile,
            'message' => $request->message,
            'created_at'  => \Carbon\Carbon::now()->toDateTimeString(),
            'updated_at'  => \Carbon\Carbon::now()->toDateTimeString(),
            ]
        );

        return response()->json(array('contact'=>$created_contact), 200);
    }


    public function courseprogress(Request $request)
    {

        $this->validate($request, [
            'course_id' => 'required',
        ]);

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

        $course = Course::where('id', $request->course_id)->first();

        $progress = CourseProgress::where('course_id', $course->id)->where('user_id', $auth->id)->first();

        
        return response()->json(array('progress'=>$progress), 200);
        
    }

    public function courseprogressupdate(Request $request)
    {

         $this->validate($request, [
            'checked' => 'required',
            'course_id' => 'required',
        ]);
        
        
        $course_return = $request->checked;

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

        $course = Course::where('id', $request->course_id)->first();

        $progress = CourseProgress::where('course_id', $course->id)->where('user_id', $auth->id)->first();

        if(isset($progress))
        {
            CourseProgress::where('course_id', $course->id)->where('user_id', '=', $auth->id)
                    ->update(['mark_chapter_id' => $course_return]);

            return response()->json('Updated sucessfully !', 200);
        }
        else
        {
        
            $chapter = CourseChapter::where('course_id', $course->id)->get();

            $chapter_id = array();

            foreach($chapter as $c)
            {
               array_push($chapter_id, "$c->id");
            }
            
            // return $course_return;

            $created_progress = CourseProgress::create([
                'course_id' => $course->id,
                'user_id' => $auth->id,
                'mark_chapter_id' => json_decode($course_return,true),
                'all_chapter_id' => $chapter_id,
                'created_at'  => \Carbon\Carbon::now()->toDateTimeString(),
                'updated_at'  => \Carbon\Carbon::now()->toDateTimeString(),
                ]
            );

            return response()->json(array('created_progress'=>$created_progress), 200);
        }
        
        
    }


    public function terms(Request $request)
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

        $terms_policy = Terms::get()->toArray();

        return response()->json(array('terms_policy'=>$terms_policy), 200);
    }

    public function career(Request $request)
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

        $career = Career::get()->toArray();

        return response()->json(array('career'=>$career), 200);
    }


    public function zoom(Request $request)
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

        $meeting = Meeting::get()->toArray();

        return response()->json(array('meeting'=>$meeting), 200);
    }


    public function bigblue(Request $request)
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

        $bigblue = BBL::get()->toArray();

        return response()->json(array('bigblue'=>$bigblue), 200);
    }



    public function coursereport(Request $request)
    {

        $this->validate($request, [
            'course_id' => 'required',
            'detail' => 'required',
        ]);

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

        $course = Course::where('id', $request->course_id)->first();


        $created_report = CourseReport::create([
            'course_id'=> $course->id,
            'user_id'=> $auth->id,
            'title'=> $course->title,
            'email'=> $auth->email,
            'detail'=> $request->detail,
            'created_at'  => \Carbon\Carbon::now()->toDateTimeString(),
            ]
        );

        return response()->json(array('course_report'=>$created_report), 200);
    }



    public function coursecontent(Request $request, $id)
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

        $result = Course::where('id','=',$id)->where('status', 1)->first();

        if(!$result){
            return response()->json('404 | Course not found !');
        }

        $order = Order::where('course_id', $result->id)->get();
        $classes = CourseClass::where('course_id', $result->id)->get();


        $overview[] = array(
            'course_title' => $result->title,
            'short_detail' => strip_tags($result->short_detail),
            'detail' => strip_tags($result->detail),
            'instructor' => $result->user->fname,
            'instructor_email' => $result->user->email,
            'instructor_detail' => strip_tags($result->user->detail),
            'user_enrolled' => count($order),
            'classes' => count($classes),
        );


        $quiz = array();

        if(isset($result->quiztopic)){

            foreach ($result->quiztopic as $key => $topic) {



                $questions = [];
                foreach($topic->quizquestion as $key => $data) {

                    if( $data->answer == 'A'){

                        $correct_answer = $data->a;

                        $options = [
                             $data->b,
                             $data->c,
                             $data->d,
                        ];

                    } 
                    elseif($data->answer == 'B')
                    {
                        $correct_answer = $data->b;

                        $options = [
                             $data->a,
                             $data->c,
                             $data->d,
                        ];
                        
                    }
                    elseif($data->answer == 'C')
                    {
                        $correct_answer = $data->c;

                        $options = [
                             $data->a,
                             $data->b,
                             $data->d,
                        ];
                        
                    }
                    elseif($data->answer == 'D'){

                        $correct_answer = $data->d;

                        $options = [
                             $data->a,
                             $data->b,
                             $data->c,
                        ];

                    }

                    $questions[] = [
                        'course' => $result->title,
                        'topic' => $topic->title,
                        'question' => $data->question,
                        'correct' => $data->answer,
                        'correct' => $correct_answer,
                        'incorrect_answers' => $options,

 
                    ];
                }


                

                $quiz[] = array(

                    'course' => $result->title,
                    'title' => $topic->title,
                    'description' => $topic->description,
                    'per_question_mark' => $topic->per_q_mark,
                    'status' => $topic->status,
                    'quiz_again' => $topic->quiz_again,
                    'due_days' =>  $topic->due_days,
                    'created_by' => $topic->created_at,
                    'updated_by' => $topic->updated_at,
                    'questions' => $questions,
                    
                    
                );
               

            }


        }

        $announcement = Announcement::where('course_id', $id)->where('status', 1)->get();
        
        $announcements = array();

        foreach ($announcement as $announc) {

            $announcements[] = array(
                'id' => $announc->id,
                'user' => $announc->user->fname,
                'course_id' => $announc->courses->title,
                'detail' => strip_tags($announc->announsment),
                'status' => $announc->status,
                'created_at' => $announc->created_at,
                'updated_at' => $announc->updated_at,
            );
        }

        $assignments = Assignment::where('course_id', $id)->get();


        $assign = array();

        foreach ($assignments as $assignment) {

            $assign[] = array(
                'id' => $assignment->id,
                'user' => $assignment->user->fname,
                'course_id' => $assignment->courses->title,
                'instructor' => $assignment->instructor->fname,
                'chapter_id' => $assignment->chapter['chapter_name'],
                'title' => $assignment->title,
                'assignment' => $assignment->assignment,
                'assignment_path' =>  url('files/assignment/'.$assignment->assignment),
                'type' => $assignment->type,
                'detail' => strip_tags($assignment->detail),
                'rating' => $assignment->rating,
                'created_at' => $assignment->created_at,
                'updated_at' => $assignment->updated_at,
            );
        }


        $appointments = Appointment::where('course_id', $id)->get();


        $appointment = array();

        foreach ($appointments as $appoint) {

            $appointment[] = array(
                'id' => $appoint->id,
                'user' => $appoint->user->fname,
                'course_id' => $appoint->courses->title,
                'instructor' => $appoint->instructor->fname,
                'title' => $appoint->title,
                'detail' => strip_tags($appoint->detail),
                'accept' => $appoint->accept,
                'reply' => $appoint->reply,
                'status' => $appoint->status,
                'created_at' => $appoint->created_at,
                'updated_at' => $appoint->updated_at,
            );
        }


        $questions = Question::where('course_id', $id)->get();


        $question = array();

        foreach ($questions as $ques) {

            $answer = [];
            foreach($ques->answers as $key => $data) {

              

                $answer[] = [
                    'course' => $data->courses->title,
                    'user' => $data->user->fname,
                    'instructor' => $data->instructor->fname,
                    'image' => $ques->instructor->user_img,
                    'imagepath' =>  url('images/user_img/'.$ques->user->user_img),
                    'question' => $data->question->question,
                    'answer' => strip_tags($data->answer),
                    'status' => $data->status,


                ];
            }

            $question[] = array(
                'id' => $ques->id,
                'user' => $ques->user->fname,
                'instructor' => $ques->instructor->fname,
                'image' => $ques->instructor->user_img,
                'imagepath' =>  url('images/user_img/'.$ques->user->user_img),
                'course' => $ques->courses->title,
                'title' => strip_tags($ques->question),
                'status' => $ques->status,
                'created_at' => $ques->created_at,
                'updated_at' => $ques->updated_at,
                'answer' => $answer,
            );
        }

        return response()->json(array('overview' => $overview, 'quiz'=>$quiz, 'announcement'=>$announcements, 'assignment'=>$assign, 'questions'=>$question, 'appointment'=>$appointment ), 200);
    }




    public function assignment(Request $request)
    {

        $this->validate($request, [
            'course_id' => 'required',
            'chapter_id' => 'required',
            'title' => 'required',
            'file' => 'required'
        ]);

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

        $course = Course::where('id', $request->course_id)->first();

        if($file = $request->file('file'))
        {
            $name = time().$file->getClientOriginalName();
            $file->move('files/assignment', $name);
            $input['assignment'] = $name;
        }

        $assignment = Assignment::create([
                'user_id' => $auth->id,
                'instructor_id' => $course->user_id,
                'course_id' => $course->id,
                'chapter_id' => $request->chapter_id,
                'title' => $request->title,
                'assignment' => $name,
                'type' => 0,
            ]
        );

        return response()->json(array('assignment'=>$assignment), 200);
        

               
    }


    public function appointment(Request $request)
    {

        $this->validate($request, [
            'course_id' => 'required',
            'title' => 'required'
        ]);

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

        $course = Course::where('id', $request->course_id)->first();

        $appointment = Appointment::create([
                'user_id' => $auth->id,
                'instructor_id' => $course->user_id,
                'course_id' => $course->id,
                'title' => $request->title,
                'detail' =>  $request->detail,
                'accept' =>  '0',
                'start_time' =>  \Carbon\Carbon::now()->toDateTimeString()
            ]
        );

        $users = User::where('id', $course->user_id)->first();


        if($appointment){
            if(env('MAIL_USERNAME')!=null) {
                try{
                    
                    /*sending email*/
                    $x = 'You get Appointment Request';
                    $request = $appointment;
                    Mail::to($users->email)->send(new UserAppointment($x, $request));


                }catch(\Swift_TransportException $e){
                    return back()->with('success', trans('flash.RequestMailError'));
                }
            }
        }

        return response()->json(array('appointment'=>$appointment), 200);
        

               
    }


    public function question(Request $request)
    {

        $this->validate($request, [
            'course_id' => 'required',
            'question' => 'required'
        ]);

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

        $course = Course::where('id', $request->course_id)->first();

        

        $question = Question::create([
                'user_id' => $auth->id,
                'instructor_id' => $course->user_id,
                'course_id' => $course->id,
                'status' => 1,
                'question' =>$request->question,
            ]
        );

        return response()->json(array('question'=>$question), 200);
        

               
    }


    public function answer(Request $request)
    {

        $this->validate($request, [
            'course_id' => 'required',
            'question_id' => 'required',
            'answer' => 'required'
        ]);

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

        $course = Course::where('id', $request->course_id)->first();

        $question = Question::where('id', $request->question_id)->first();

        

        $question = Answer::create([
                'ans_user_id' => $auth->id,
                'ques_user_id' => $question->user_id,
                'instructor_id' => $course->user_id,
                'course_id' => $course->id,
                'question_id' => $question->id,
                'status' => 1,
                'answer' =>$request->answer,
            ]
        );

        return response()->json(array('question'=>$question), 200);
        

               
    }


    public function appointmentdelete(Request $request, $id)
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

        
        Appointment::where('id', $id)->delete();

        return response()->json('Deleted Successfully !', 200);

    }





}