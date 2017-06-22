package com.mybatis.service;

        import com.mybatis.model.Employee;

        import java.util.List;

/**
 * Created by DJ on 2017/6/22.
 */
public interface EmployeeService {
    Employee getEmployee(int id);

    List<Employee> getEmployees();
}