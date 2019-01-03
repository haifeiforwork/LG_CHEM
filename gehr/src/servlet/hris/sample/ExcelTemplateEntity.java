package servlet.hris.sample;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-07-14.
 */
public class ExcelTemplateEntity extends EntityData {

    public String code_group;
    public String group_nm;
    public String biz_cd;
    public Integer seq;

    public ExcelTemplateEntity() {
    }

    public ExcelTemplateEntity(String code_group, String group_nm, String biz_cd) {
        this.code_group = code_group;
        this.group_nm = group_nm;
        this.biz_cd = biz_cd;
    }

    public String getCode_group() {
        return code_group;
    }

    public void setCode_group(String code_group) {
        this.code_group = code_group;
    }

    public String getGroup_nm() {
        return group_nm;
    }

    public void setGroup_nm(String group_nm) {
        this.group_nm = group_nm;
    }

    public String getBiz_cd() {
        return biz_cd;
    }

    public void setBiz_cd(String biz_cd) {
        this.biz_cd = biz_cd;
    }
}
