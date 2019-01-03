/**
 * SysAuthGroupRFC.java
 * Competency Requirements Data format
 * [���� RFC] : ZHRC_RFC_GET_AUTHGROUP
 * 
 * @author lsa
 * @version 1.0, 2007/04/16
 */

package hris.sys.rfc;

import com.sns.jdf.EntityData;

public class SysAuthGroupData extends EntityData 
{
    public String MANDT     ;        //Ŭ���̾�Ʈ
    public String COMMONCODE;        //�����ڵ�  
    public String DETAILCODE;        //���ڵ�  
    public String DETAILNAME;        //���ڵ��
    public String ETC       ;        //���      
    public String REG_EMD_ID;        //�����    
    public String REG_YMD   ;        //�����    
    public String MOD_EMP_ID;        //������    
    public String MOD_YMD   ;        //������    
    public String PROGRAMID ;        //���α׷�ID
}