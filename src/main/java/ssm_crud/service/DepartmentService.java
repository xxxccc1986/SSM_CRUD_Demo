package ssm_crud.service;

import ssm_crud.bean.Department;

import java.util.List;

/**
 * @author hcxs1986
 * @version 1.0
 * @description: TODO
 * @date 2022/4/19 15:50
 */
public interface DepartmentService {

    List<Department> getDeptNames();
}
