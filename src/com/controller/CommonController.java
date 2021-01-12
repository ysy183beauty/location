package com.controller;
import com.model.Camera;
import com.model.User;
import com.service.CommonService;
import com.util.AppSendUtils;
import com.util.MD5Util;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Controller
public class CommonController {
    @Resource
    private CommonService commonService;
    private Map<String,Object> map=null;

    /**
     * 加载单点列表页面
     * @return
     */
    @RequestMapping(value = "/toList",method = RequestMethod.GET)
    public ModelAndView toList(){
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/pages/list");
        return mav;
    }

    /**
     * 加载多点页面
     */
    @RequestMapping(value = "/toMoreList",method = RequestMethod.GET)
    public ModelAndView toMoreList(){
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/pages/moreList");
        return mav;
    }

    /**
     * 跳转到菜单列表页面信息
     */
    @RequestMapping(value = "/toMenu",method = RequestMethod.GET)
    public ModelAndView toMenu(){
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/pages/menu");
        return mav;
    }

    /**
     * 新增摄像头信息
     * @return
     */
    @RequestMapping(value = "/toAdd",method ={RequestMethod.GET,RequestMethod.POST})
    public ModelAndView toAdd(){
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/pages/addCamera");
        return mav;
    }

    /**
     * 编辑摄像头信息
     * @return
     */
    @RequestMapping(value = "/toEditList",method ={RequestMethod.GET,RequestMethod.POST})
    public ModelAndView toEditList(HttpServletRequest request){
        String msg=request.getParameter("msg")==null?"":request.getParameter("msg");
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/pages/editCameraList");
        mav.addObject("msg",msg);
        return mav;
    }

    /**
     * 编辑摄像头信息
     * @return
     */
    @RequestMapping(value = "/toEditCamera",method ={RequestMethod.GET,RequestMethod.POST})
    public ModelAndView toEditCamera(HttpServletRequest request){
        String id=request.getParameter("id")==null?"":request.getParameter("id");
        Camera camera = commonService.selectCameraById(Integer.parseInt(id));
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/pages/editCamera");
        mav.addObject("cameraName",camera.getCameraName());
        mav.addObject("lng",camera.getLng());
        mav.addObject("lat",camera.getLat());
        mav.addObject("id",camera.getId());
        return mav;
    }

    /**
     *加载到地图页面信息
     */
    @RequestMapping(value = "/toMap",method = {RequestMethod.POST,RequestMethod.GET})
     public ModelAndView toMap(HttpServletRequest request){
         String cameraName=request.getParameter("cameraName");
         String lng=request.getParameter("lng");
         String lat=request.getParameter("lat");
         ModelAndView mav = new ModelAndView();
         mav.addObject("cameraName",cameraName);
         mav.addObject("lngLat",lng+","+lat);
         mav.setViewName("/pages/map");
         return mav;
     }

    @ResponseBody
    @RequestMapping(value = "/selectAll",method = RequestMethod.POST)
    public Map<String,Object> selectAll(HttpServletRequest request, HttpServletResponse response){
       map=new HashMap<>();
       //获取当前页数
      String page=request.getParameter("page")==null?"1":request.getParameter("page");
      String cameraName=request.getParameter("cameraName")==null?"":request.getParameter("cameraName");
      Map<String,Object> parameters=new HashMap<>();
      parameters.put("cameraName",cameraName);
      parameters.put("pagestart",0);
      parameters.put("pagesize",Integer.parseInt(page)*10);
      List<Camera> cameras=commonService.selectAll(parameters);
      map.put("data",cameras);
      return map;
    }

    /**
     * 多点导航路线信息
     */
    @ResponseBody
    @RequestMapping(value = "/selectMoreAll",method = RequestMethod.POST)
    public Map<String,Object> selectMoreAll(HttpServletRequest request, HttpServletResponse response){
        map=new HashMap<>();
        //获取当前页数
        String page=request.getParameter("page")==null?"1":request.getParameter("page");
        String cameraName=request.getParameter("cameraName")==null?"":request.getParameter("cameraName");
        //获取提交类型
        String type=request.getParameter("type")==null?"":request.getParameter("type");
        Map<String,Object> parameters=new HashMap<>();
        Integer start=0;//开始位置
        Integer end=0;//结束位置
        if("more".equals(type)){
           start=(Integer.parseInt(page)-1)*10;
           end=10;
        }else if("query".equals(type)){
            start=0;
            end=Integer.parseInt(page)*10;
        }
        parameters.put("cameraName",cameraName);
        parameters.put("pagestart",start);
        parameters.put("pagesize",end);
        List<Camera> cameras=commonService.selectAll(parameters);
        map.put("data",cameras);
        return map;
    }

    /**
     * 接受选中的多个定位点的位置
     */
    @RequestMapping(value = "/toMoreMap",method = RequestMethod.POST)
    public ModelAndView toMoreMap(HttpServletRequest request, HttpServletResponse response){
        String data=request.getParameter("data");
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/pages/moreMap");
        mav.addObject("data",data);
        return mav;
    }

    /**
     * 更新为百度的经纬度信息
     */
    @RequestMapping(value = "/updateLngLat",method ={RequestMethod.GET,RequestMethod.POST})
    public void updateLngLat(){
        List<Camera> cameras=commonService.selectBaseInfo();
        List<Camera> data=Change(cameras);
        //调用批量更新
        System.out.println("开始更新数据信息");
        commonService.updateBatchBaseCarmera(data);
        System.out.println("结束数据更新信息");
    }

    /**
     * 实现登录功能
     */
    @RequestMapping(value = "/login",method =RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> login(HttpServletRequest request, HttpServletResponse response){
         map=new HashMap<>();
        try {
            String userName=request.getParameter("username")==null?"":request.getParameter("username");
            String pwd=request.getParameter("password")==null?"":request.getParameter("password");
            String passWord= MD5Util.getMD5Str(pwd);
            User user=new User();
            user.setUserName(userName);
            user.setPassWord(passWord);
            Integer i=commonService.login(user);
            if(i==0){//用户名或密码出错
              map.put("msg","用户名或密码出错");
              map.put("flag",false);
            }else{
                map.put("flag",true);
                request.getSession().setAttribute("loginUser",user);
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            map.put("msg","请联系管理员");
            map.put("flag",false);
        }
        return map;
    }

    /**
     * GPS经纬度转换为百度地图
     */
    public List<Camera> Change(List<Camera> data){
        String coords=null;
        String result=null;
        JSONObject object=null;
        List<Camera> list=new ArrayList<>();
        for (Camera camera:data){
            coords=camera.getLng()+","+camera.getLat();
            result = AppSendUtils.connectURL("http://api.map.baidu.com/geoconv/v1/?coords="+coords+"&from=1&to=5&output=json&ak=e3ZohdqyB0RL98hFOiC29xqh","");
            if(result!=null){
                object= JSONObject.fromObject(result);
                if(Integer.parseInt(object.get("status").toString())==0){
                    JSONArray arr = JSONArray.fromObject(object.get("result"));
                    for (int i=0;i<arr.size();i++){
                        camera.setBdLng(Double.parseDouble(arr.getJSONObject(i).get("x").toString()));
                        camera.setBdLat(Double.parseDouble(arr.getJSONObject(i).get("y").toString()));
                    }
                }
            }
            list.add(camera);
        }
        return list;
    }

    /**
     * 保留数据信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveCameraInfo",method =RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> saveCameraInfo(HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        String carmerNum=request.getParameter("carmerNum");
        String cameraName=request.getParameter("cameraName")==null?"":request.getParameter("cameraName");
        try {
            double lng=Double.parseDouble(request.getParameter("lng"));
            double lat=Double.parseDouble(request.getParameter("lat"));
            String regionName=request.getParameter("regionName");
            Camera camera=new Camera();
            camera.setCameraName(carmerNum+" "+cameraName);
            camera.setLng(lng);
            camera.setLat(lat);
            camera.setRegionName(regionName);
            List<Camera> list=new ArrayList<>();
            list.add(camera);
            Camera cm = this.Change(list).get(0);
            commonService.addCameraInfo(cm);
            map.put("result",true);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            map.put("result",false);
        }
        return map;
    }

    /**
     * 更新数据信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/updateCameraInfo",method =RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> updateCameraInfo(HttpServletRequest request){
        Map<String,Object> map=new HashMap<>();
        String cameraName=request.getParameter("cameraName");
        String id=request.getParameter("id");
        try {
            double lng=Double.parseDouble(request.getParameter("lng"));
            double lat=Double.parseDouble(request.getParameter("lat"));
            Camera camera=new Camera();
            camera.setId(Integer.parseInt(id));
            camera.setCameraName(cameraName);
            camera.setLng(lng);
            camera.setLat(lat);
            List<Camera> list=new ArrayList<>();
            list.add(camera);
            Camera cm = this.Change(list).get(0);
            commonService.updateCamera(cm);
            map.put("result",true);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            map.put("result",false);
        }
        return map;
    }
}
