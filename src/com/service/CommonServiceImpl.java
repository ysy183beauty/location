package com.service;
import com.mapper.CommonMapper;
import com.mapper.UserMapper;
import com.model.Camera;
import com.model.User;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
@Service("commonService")
public class CommonServiceImpl implements CommonService {
    @Resource
    private CommonMapper commonMapper;
    @Resource
    private UserMapper userMapper;
    @Override
    public List<Camera> selectAll(Map<String,Object> map) {
        return commonMapper.selectAll(map);
    }

    @Override
    public Integer login(User user) {
        return userMapper.login(user);
    }

    @Override
    public List<Camera> selectBaseInfo() {
        return commonMapper.selectBaseInfo();
    }

    @Override
    public void updateBatchBaseCarmera(List<Camera> list) {
        commonMapper.updateBatchBaseCarmera(list);
    }

    @Override
    public void addCameraInfo(Camera camera) {
        commonMapper.addCameraInfo(camera);
    }

    @Override
    public Camera selectCameraById(Integer id) {
        return commonMapper.selectCameraById(id);
    }

    @Override
    public void updateCamera(Camera camera) {
        commonMapper.updateCamera(camera);
    }
}
