/**
 * SysAuthGroupRFC.java
 * Competency Requirements Data format
 * [관련 RFC] : ZHRC_RFC_GET_AUTHGROUP
 * 
 * @author lsa
 * @version 1.0, 2007/04/16
 */

package hris.sys.rfc;

import com.sns.jdf.EntityData;

public class SysAuthGroupData extends EntityData 
{
    public String MANDT     ;        //클라이언트
    public String COMMONCODE;        //공통코드  
    public String DETAILCODE;        //상세코드  
    public String DETAILNAME;        //상세코드명
    public String ETC       ;        //비고      
    public String REG_EMD_ID;        //등록자    
    public String REG_YMD   ;        //등록일    
    public String MOD_EMP_ID;        //수정자    
    public String MOD_YMD   ;        //수정일    
    public String PROGRAMID ;        //프로그램ID
}