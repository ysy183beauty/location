package com.mapper;

import com.model.Camera;

import java.util.List;
import java.util.Map;

public interface CommonMapper {
    //查询所有的数据信息
    List<Camera> selectAll(Map<String, Object> map);
    List<Camera> selectBaseInfo();
    void updateBatchBaseCarmera(List<Camera> list);
    //添加数据信息
    void addCameraInfo(Camera camera);
    //通过主键查询
    Camera selectCameraById(Integer id);
    void updateCamera(Camera camera);
}