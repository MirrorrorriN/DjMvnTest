package com.mybatis.controller;

        import com.mybatis.model.Employee;
        import com.mybatis.service.EmployeeService;
        import org.springframework.beans.factory.annotation.Autowired;
        import org.springframework.stereotype.Controller;
        import org.springframework.web.bind.annotation.RequestMapping;
        import org.springframework.web.bind.annotation.RequestMethod;

        import java.util.List;
        import java.util.Map;

/**
 * Created by DJ on 2017/6/22.
 */
@Controller
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    @RequestMapping(value="/listAll",method= RequestMethod.GET)
    public String list(Map<String,Object> map){
        List<Employee> employees = employeeService.getEmployees();
       /*测试用
      if(employees==null)
         System.out.println("null");
      else
         System.out.println(employees);*/

        map.put("employees",employees);
        return "list";
    }


}

