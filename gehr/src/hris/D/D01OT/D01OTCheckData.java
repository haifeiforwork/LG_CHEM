package hris.D.D01OT;

/**
 * D01OTCheckData.java
 *  한계결정한 시간 정보를 담아오는 데이터 구조
 *   [관련 RFC] : ZHRW_RFC_IS_AVAIL_OVERTIME
 *
 * @author 김도신
 * @version 1.0, 2002/07/04
 */
public class D01OTCheckData extends com.sns.jdf.EntityData {
    public String ERRORTEXTS;      //에러 text
    public String BEGUZ     ;      //시작시간
    public String ENDUZ     ;      //종료시간
    public String STDAZ     ;      //초과근무시간

    //Global
    public String PERNR ;
    public String BEGZT ;
    public String ENDZT ;
    public String ZMODN ;
    public String FTKLA ;
    public String DATUM ;
}
