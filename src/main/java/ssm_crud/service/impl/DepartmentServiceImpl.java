package ssm_crud.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssm_crud.bean.Department;
import ssm_crud.dao.DepartmentMapper;
import ssm_crud.service.DepartmentService;

import java.util.List;

/**
 * @author hcxs1986
 * @version 1.0
 * @description: TODO
 * @date 2022/4/19 15:51
 */
@Service
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    DepartmentMapper departmentMapper;

    @Override
    public List<Department> getDeptNames() {
        return  departmentMapper.selectByExample(null);
    }
}
