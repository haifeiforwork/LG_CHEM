package	hris.E.E16Health;

/**
 * E16Health9419Data.java
 * 임직원건강관리카드에 건강검진결과에   대한 데이터
 *   [관련 RFC] : ZHRW_RFC_HEALTH_CARD_DISPLAY
 * 
 * @author lsa   
 * @version 1.0, 2010/05/31
 */
public class E16Health9419Data extends com.sns.jdf.EntityData {

    public String MEDI_QTAR;     //건강검진 분기
    public String MEDI_BPH ;      //고혈압 혈압(고)
    public String MEDI_BPHR;     //유소견 코드
    public String MEDI_BPL;       //고혈압 혈압(저)
    public String MEDI_BPLR;     //유소견 코드
    public String MEDI_TTC;      //고지혈증 총콜레스트롤
    public String MEDI_TTCR;    //유소견 코드    
    public String MEDI_TRG;      //고지혈증 중성지방
    public String MEDI_TRGR;    // 검사유형 텍스트
    public String MEDI_HDL;    // 고지혈증 고밀도(HDL) 콜레스테롤 	                              
    public String MEDI_HDLR;    // 유소견 코드 	                              
    public String MEDI_LDL;    // 고지혈증 저밀도(LDL) 콜레스테롤	                               
    public String MEDI_LDLR;    // 유소견 코드                             
    
    public String MEDI_GOT;     //간장질환 GOT
    public String MEDI_GOTR;   //유소견 코드    
    public String MEDI_GPT ;    //간장질환 GPT
    public String MEDI_GPTR;    //유소견 코드
    public String MEDI_GGT;     //간장질환 GGT
    public String MEDI_GGTR;   //유소견 코드
    public String MEDI_GLU;     //당뇨 식전혈당
    public String MEDI_GLUR;   //유소견 코드
    
    public String REAL_DATE;   //실검진일자
    public String STEXT;          //오브젝트 이름
}
