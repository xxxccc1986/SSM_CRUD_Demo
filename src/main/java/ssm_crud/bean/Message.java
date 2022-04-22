package ssm_crud.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * @author hcxs1986
 * @version 1.0
 * @description: 通用的返回类
 * @date 2022/4/18 21:35
 */
public class Message {
    //状态码 100-成功 200-失败
    private int code;
    //提示信息
    private  String message;

    //服务器要返回给浏览器的数据
    private Map<String,Object> extend = new HashMap<>();

    public static Message success(){
        Message message = new Message();
        message.setCode(100);
        message.setMessage("处理成功");
        return message;
    }

    public static Message fail(){
        Message message = new Message();
        message.setCode(200);
        message.setMessage("处理失败");
        return message;
    }

    public Message add(String key,Object value){
        this.getExtend().put(key,value);
        return this;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

    @Override
    public String toString() {
        return "Message{" +
                "code=" + code +
                ", message='" + message + '\'' +
                ", extend=" + extend +
                '}';
    }
}
