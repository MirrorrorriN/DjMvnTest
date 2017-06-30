package com.mybatis.test;
import com.mybatis.model.Employee;
        import com.mybatis.service.EmployeeService;
        import org.junit.Test;
        import org.junit.runner.RunWith;
        import org.springframework.beans.factory.annotation.Autowired;
        import org.springframework.test.context.ContextConfiguration;
        import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

        import java.util.List;

/**
 * Created by DJ on 2017/6/22.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:spring-mybatis.xml" })
public class EmployeeTest {

    @Autowired
    private EmployeeService employeeService;

    @Test
    public void testGetEmployeeById(){
        Employee employee = employeeService.getEmployee(1);
        System.out.print(employee);
    }

    @Test
    public void testGetAll(){
        List<Employee> employees=employeeService.getEmployees();
        System.out.print(employees);
    }
}
