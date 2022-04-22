package test;

import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import ssm_crud.bean.Employee;

import java.util.List;

/**
 * @author hcxs1986
 * @version 1.0
 * @description: TODO
 * @date 2022/4/18 15:17
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:spring.xml","classpath:springMVC.xml"})
public class MVCTest {
    //传入SpringMVC的ioc
    @Autowired
    WebApplicationContext context;

    //虚拟的mvc请求，获取到处理结果
    MockMvc mockMvc;

    @Before
    public void initMOkcMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        //模拟请求拿到返回值数据
        MvcResult pageNo = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pageNo", "5")).andReturn();

        //请求成功后，请求域中会有pageInfo
        MockHttpServletRequest request = pageNo.getRequest();
        PageInfo<Employee> attribute = (PageInfo<Employee>) request.getAttribute("pageInfo");
        System.out.println("当前页面：" + attribute.getPageNum());
        System.out.println("总页码：" + attribute.getPages());
        System.out.println("总记录数：" + attribute.getTotal());
        System.out.print("在页面需要连续显示的页码：");
        int[] pages = attribute.getNavigatepageNums();
        for (int i = 0; i < pages.length; i++) {
            System.out.print(" " + pages[i]);
        }
        System.out.println();


        //获取员工数据
        List<Employee> emps = attribute.getList();
        emps.forEach(System.out :: println);

    }


}
