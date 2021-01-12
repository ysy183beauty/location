package com.mapper;

import com.model.User;

public interface UserMapper {
    /**
     * 登录信息
     * @param user
     * @return
     */
    Integer login(User user);
}
