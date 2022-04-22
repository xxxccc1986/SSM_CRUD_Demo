package ssm_crud.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import ssm_crud.bean.Department;
import ssm_crud.bean.Message;
import ssm_crud.service.DepartmentService;


import java.util.List;

/**
 * @author hcxs1986
 * @version 1.0
 * @description: TODO
 * @date 2022/4/19 15:49
 */
@Controller
public class DepartmentController {

    @Autowired
    DepartmentService departmentService;

    /**
     * Description : 查询部门的信息
     * @date 2022/4/19
     * @return ssm_crud.bean.Message
     **/
    @ResponseBody
    @RequestMapping(value = {"/depts"},method = RequestMethod.GET)
    public Message getDepts(){
        List<Department> depts = departmentService.getDeptNames();
        return Message.success().add("depts",depts);
    }




}
