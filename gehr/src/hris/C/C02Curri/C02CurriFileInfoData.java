package hris.C.C02Curri;

/**
 * C02CurriFileInfoData.java
 * 교육과정 문서 링크정보를 담당하는 Data   3C6009B8A6DEE0B4E1000000A5F4EB51
 *   [관련 RFC] : ZHRS_RFC_VIEW_ATTA
 * 
 * @author 박영락
 * @version 1.0, 2002/02/06
 */
public class C02CurriFileInfoData extends com.sns.jdf.EntityData {

    public String OBJDES       ;   //파일명
    public String OBJLEN       ;   //파일크기
    public String FILE_EXT     ;   //확장자
    public String PHIO_ID      ;   //오브젝트아이디 실제 파일을 갖어오는데사용
    public String STOR_CAT     ;   //STOR_CAT  실제 파일을 갖어오는데사용

}
  