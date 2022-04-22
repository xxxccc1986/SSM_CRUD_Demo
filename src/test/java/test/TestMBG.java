package test;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import ssm_crud.bean.Department;
import ssm_crud.bean.Employee;
import ssm_crud.dao.DepartmentMapper;
import ssm_crud.dao.EmployeeMapper;

import java.util.UUID;

/**
 * @author hcxs1986
 * @version 1.0
 * @description: 测试逆向工程生成的dao层是否能正常执行
 * 使用Spring单元测试可以自动注入需要的组件
 * 1.导入SringTest依赖
 * 2.@ContextConfiguration指定Spring配置文件的位置
 * 3.直接使用autowired要使用的组件
 * @date 2022/4/17 23:38
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring.xml"})
public class TestMBG {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;
    /**
     * Description : 测试部门表
     * @date 2022/4/17
     * @return void
     **/
    @Test
    public void test(){
        //1.创建IOC容器
        ApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
        //从IOC容器中获取mapper
        Department department = context.getBean(Department.class);
    }

    @Test
    public void test1(){
        //测试插入部门信息
//        int i1 = departmentMapper.insertSelective(new Department(null, "a"));
//        int i2 = departmentMapper.insertSelective(new Department(null, "b"));
//        int i3 = departmentMapper.insertSelective(new Department(null, "c"));
//        System.out.println(i1);
//        System.out.println(i2);
//        System.out.println(i3);

        //测试插入员工信息
//        employeeMapper.insertSelective(new Employee(null,"emp1","男","emp1@qq.com",1));
//        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
//        for (int i = 0;i < 500;i++){
//            String name = UUID.randomUUID().toString().substring(0, 5) + "" + i;
//            mapper.insertSelective(new Employee(null,name,"M",name + "@test.com",2));
//        }


    }


}
