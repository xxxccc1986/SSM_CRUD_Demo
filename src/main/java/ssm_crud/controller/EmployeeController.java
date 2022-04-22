package ssm_crud.controller;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import ssm_crud.bean.Employee;
import ssm_crud.bean.Message;
import ssm_crud.service.EmployeeService;
import javax.validation.Valid;
import java.util.*;


/**
 * @author hcxs1986
 * @version 1.0
 * @description: 处理员工表的增删改查操作
 * @date 2022/4/18 11:44
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * Description : 查询员工数据(分页查询)
     * @date 2022/4/18
     * @param pageNo 查询的页面
     * @return com.github.pagehelper.PageInfo<ssm_crud.bean.Employee>
     **/
    @ResponseBody
    @RequestMapping(value = {"/emps"})
    public Message getAllEmp(@RequestParam("pageNo") Integer pageNo){
    //分页功能需要在查询之前开启
    //传入页码和每页需要展示的数据量
    PageHelper.startPage(pageNo,5);
    //在分页功能开启后的查询即为分页查询
    List<Employee> emps = employeeService.getAllEmp();
    //使用PageInfo类来封装查询后的结果,因此只需要将pageInfo回传给页码即可
    PageInfo<Employee> pageInfo = new PageInfo<>(emps, 5);
    return Message.success().add("pageInfo",pageInfo);
}


    /**
     * Description : 检查邮箱是否可用
     * @date 2022/4/19
     * @param email 被验证的邮箱
     * @return ssm_crud.bean.Message
     **/
    @ResponseBody
    @RequestMapping(value = {"/checkEmail"},method = RequestMethod.GET)
        public Message checkEmail(@RequestParam("email") String email){
        //数据库验证邮箱是否已存在
        boolean result = employeeService.selectEmail(email);
        if (result){
            return Message.success();
        }else {
            return Message.fail().add("val_msg","邮箱已存在");
        }
    }

    /**
     * Description : 添加员工
     * @date 2022/4/19
     * @param employee 添加的员工信息
     * @return ssm_crud.bean.Message
     **/
    @ResponseBody
    @RequestMapping(value = "/emps",method = RequestMethod.POST)
    public Message addEmp(@Valid Employee employee, BindingResult result){
        if (result.hasErrors()){
            HashMap<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError error : errors) {
                System.out.println("错误的字段名：" + error.getField());
                System.out.println("错误信息：" + error.getDefaultMessage());
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Message.fail().add("errors",map);
        }else{
            employeeService.addEmp(employee);
            return Message.success();
        }
    }


    /**
     * Description : 根据id查询员工信息
     * @date 2022/4/20
     * @param id 员工的id
     * @return ssm_crud.bean.Message
     **/
    @RequestMapping(value = {"/emps/{id}"},method = RequestMethod.GET)
    @ResponseBody
    public Message getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.selectEmp(id);
        return Message.success().add("employee",employee);
    }

    /**
     * Description : 根据id修改员工信息
     * @date 2022/4/20
     * @param employee 员工的信息
     * @return ssm_crud.bean.Message
     **/
    @ResponseBody
    @RequestMapping(value = {"/emps/{empId}"},method = RequestMethod.PUT)
    public Message updateEmp(Employee employee){
        System.out.println(employee);
        employeeService.updateEmp(employee);
        return Message.success();
    }

    /**
     * Description : 根据id删除员工
     * @date 2022/4/20
     * @param id 被删除的id员工
     * @return ssm_crud.bean.Message
     **/
    @ResponseBody
    @RequestMapping(value = {"/emps/{id}"},method = RequestMethod.DELETE)
    public Message deleteEmp(@PathVariable("id") Integer id){
        employeeService.delete(id);
        return Message.success();
    }

    /**
     * Description : 批量删除员工
     * @date 2022/4/20
     * @param nums 被删除的员工id
     * @return ssm_crud.bean.Message
     **/
    @ResponseBody
    @RequestMapping(value = {"/emps"},method = RequestMethod.DELETE)
    public Message deleteEmp(@RequestBody String nums){
        try {
            //将前端传来的json字符串转换为map集合对象
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String,String> map = objectMapper.readValue(nums, Map.class);

            //从map集合对象中获取所有被删除的id
            String n = map.get("nums");
            String[] split = n.split(",");
            for (String id : split){
                //将id转换为数字
                Integer empId = Integer.parseInt(id);
                //调用service层进行删除
                employeeService.delete(empId);
            }
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return Message.success();
    }

}
