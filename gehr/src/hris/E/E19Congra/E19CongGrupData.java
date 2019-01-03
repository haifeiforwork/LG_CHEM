package hris.E.E19Congra;

/**
 * E19CongcondData.java
 * 인사하위영역 인사그룹핑 Code
 *   [관련 RFC] : ZHRA_RFC_GET_GRUP_NUMB
 * @author lsa
 * @version 1.0, 2014/04/18
 */
public class E19CongGrupData extends com.sns.jdf.EntityData
{ 
    public String MANDT		;//클라이언트          
    public String SPRSL           ;//언어 키             
    public String BUKRS           ;//회사 코드           
    public String UPMU_FLAG       ;//업무구분 그룹 지시자
    public String UPMU_TYPE       ;//업무구분            
    public String GRUP_NUMB       ;//사업장              
    public String GRUP_NAME       ;//사업장명    
    
}