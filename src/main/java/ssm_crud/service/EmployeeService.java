package ssm_crud.service;

import ssm_crud.bean.Employee;
import java.util.List;

/**
 * @author hcxs1986
 * @version 1.0
 * @description: TODO
 * @date 2022/4/18 11:53
 */

public interface EmployeeService {

    List<Employee> getAllEmp();

    void addEmp(Employee employee);

    boolean selectEmail(String email);

    Employee selectEmp(Integer id);

    int updateEmp(Employee employee);

    void delete(Integer id);
}
