package com.service;

import com.model.Camera;
import com.model.User;
import java.util.List;
import java.util.Map;
public interface CommonService {
    //查询所有的数据信息
    List<Camera> selectAll(Map<String, Object> map);
    //登录信息
    Integer login(User user);
    List<Camera> selectBaseInfo();
    void updateBatchBaseCarmera(List<Camera> list);
    //添加数据信息
    void addCameraInfo(Camera camera);
    Camera selectCameraById(Integer id);
    void updateCamera(Camera camera);
}
