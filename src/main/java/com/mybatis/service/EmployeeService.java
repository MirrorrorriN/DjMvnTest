package com.mybatis.service;

        import com.kepler.annotation.Service;
        import com.mybatis.model.Employee;

        import java.util.List;

/**
 * Created by DJ on 2017/6/25.
 */
@Service(version="0.0.2")
public interface EmployeeService {
    Employee getEmployee(Integer id);

    List<Employee> getEmployees();
}