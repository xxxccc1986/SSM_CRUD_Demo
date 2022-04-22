package ssm_crud.service.impl;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ssm_crud.bean.Employee;
import ssm_crud.bean.EmployeeExample;
import ssm_crud.dao.EmployeeMapper;
import ssm_crud.service.EmployeeService;
import java.util.List;

/**
 * @author hcxs1986
 * @version 1.0
 * @description: TODO
 * @date 2022/4/18 12:13
 */
@Service
public class EmployeeServiceImpl implements EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;

    /**
     * Description : 查询所有员工数据
     * @date 2022/4/18
     * @return java.util.List<ssm_crud.bean.Employee>
     **/
    @Override
    public List<Employee> getAllEmp() {
        return  employeeMapper.selectByExampleWithDept(null);
    }

    /**
     * Description : 新增员工
     * @date 2022/4/19
     * @param employee 保存的员工信息
     * @return int
     **/
    @Override
    public void addEmp(Employee employee) {
        employeeMapper.insert(employee);
    }

    /**
     * Description : 判断增加的邮箱是否存在
     * @date 2022/4/19
     * @param email 传入的邮箱
     * @return boolean
     **/
    @Override
    public boolean selectEmail(String email) {
        EmployeeExample example = new EmployeeExample();
        example.createCriteria().andEmailEqualTo(email);
        long count = employeeMapper.countByExample(example);
        return count == 0;
    }

    /**
     * Description : 根据id查询员工
     * @date 2022/4/20
     * @param id
     * @return ssm_crud.bean.Employee
     **/
    @Override
    public Employee selectEmp(Integer id) {
       return employeeMapper.selectByPrimaryKey(id);
    }

    /**
     * Description : 修改员工信息
     * @date 2022/4/20
     * @param employee
     * @return int
     **/
    @Override
    public int updateEmp(Employee employee) {
       return employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**
     * Description : 根据id删除员工
     * @date 2022/4/20
     * @param id
     * @return void
     **/
    @Override
    public void delete(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }
}
