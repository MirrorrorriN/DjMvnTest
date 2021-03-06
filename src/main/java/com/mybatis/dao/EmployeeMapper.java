package com.mybatis.dao;

import com.mybatis.model.Employee;
import org.apache.ibatis.annotations.Select;

import java.util.List;


/**
 * Created by DJ on 2017/6/25.
 */

public interface EmployeeMapper {
    @Select("select id,lastName,email from employee where id=#{id}")
    Employee getEmployeeById(int id);

    @Select("select * from employee")
    List<Employee> getAllEmployees();
}