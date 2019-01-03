/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : Global육성POOL                                              */
/*   Program Name : Global육성POOL 각각의 상세화면                              */
/*   Program ID   : F71GlobalDetailListData                                     */
/*   Description  : Global육성POOL 각각의 상세화면 조회를 위한 DATA 파일        */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-03-16 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package hris.F;   
 
/**
 * F71GlobalDetailListData 
 *  Global육성POOL 각각의 상세화면 내용을 담는 데이터 
 *  
 * @author 유용원
 * @version 1.0,  
 */
public class F71GlobalDetailListData extends com.sns.jdf.EntityData {
    public String PERNR        ;  //사원번호                   
    public String ENAME        ;  //사원 또는 지원자의 포맷이름
    public String STEXT        ;  //오브젝트이름               
    public String PTEXT        ;  //사원서브그룹이름           
    public String TITEL        ;  //직위                       
    public String TITL2        ;  //직책                       
    public String TRFGR        ;  //급여그룹                   
    public String TRFST        ;  //급여레벨                   
    public String VGLST        ;  //비교급여범위레벨           
    public String STELL_TEXT   ;  //직무명                     
    public String DAT          ;  //일자                       
    public String GNSOK        ;  //근속년수                   
    public String OLDS         ;  //연령                       
    public String HPI_MARK     ;  //HPI 여부                   
    public String REGI_MARK    ;  //지역전문가 여부          
    public String HPREG_MARK   ;  //HPI&지역전문가 여부  
    public String UMBA_MARK    ;  //육성 MBA 여부        
    public String HPUMB_MARK   ;  //HPI&육성 MBA 여부    
    public String CORP_MARK    ;  //법인장교육이수자 여부
    public String SMBA_MARK    ;  //확보MBA 여부         
    public String DEGR_MARK    ;  //해외학위자 여부      
    public String RND_MARK     ;  //R&D박사 여부         
    public String FORE_MARK    ;  //국내외국인근무자 여부
    public String CHIN_MARK    ;  //중국지역경험자 여부  
    public String NCHIN_MARK   ;  //중국外지역경험자 여부
    public String TOEI_MARK    ;  //TOEIC 800점 이상자   
    public String HSK_MARK     ;  //HSK 5등급 이상자     
    public String LGAO_MARK    ;  //LGA 3.5점 이상자     
    public String CN_MARK      ;  //중국어 전공자        
    public String ENCN_MARK    ;  //영어&중국어 가능자
    public String LART_TEXT1   ;  //대학교명          
    public String FTEXT1       ;  //대학교전공        
    public String LART_TEXT2   ;  //대학원명          
    public String FTEXT2       ;  //대학원전공        
    public String TOEI_SCOR    ;  //TOEIC 인정점수    
    public String JPT_SCOR     ;  //JPT 인정점수      
    public String LANG_LEVL    ;  //HSK 등급          
    public String LGAX_SCOR    ;  //LGA-LAP Oral      
    public String PERS_APP1    ;  //직전1개년 평가    
    public String PERS_APP2    ;  //직전2개년 평가    
    public String PERS_APP3    ;  //직전3개년 평가    
    public String REGI_SLAND   ;  //연수지역          
    public String REGI_YEAR    ;  //연수년도          
    public String MBA_DETAI1   ;  //육성MBA유형1      
    public String MBA_YEAR1    ;  //육성MBA시작년도1              
    public String MBA_SCHOO1   ;  //P/G명1          
    public String MBA_DETAI2   ;  //육성MBA유형2    
    public String MBA_YEAR2    ;  //육성MBA시작년도2
    public String MBA_SCHOO2   ;  //P/G명2          
    public String MBA_DETAI3   ;  //육성MBA유형3    
    public String MBA_YEAR3    ;  //육성MBA시작년도3
    public String MBA_SCHOO3   ;  //P/G명3          
    public String MBA_DETAI4   ;  //육성MBA유형4    
    public String MBA_YEAR4    ;  //육성MBA시작년도4
    public String MBA_SCHOO4   ;  //P/G명4          
    public String MBA_DETAI5   ;  //육성MBA유형5    
    public String MBA_YEAR5    ;  //육성MBA시작년도5
    public String MBA_SCHOO5   ;  //P/G명5          
    public String CORP_AREA    ;  //법인연수지역    
    public String MBA_SLAND    ;  //확보MBA 국가   
    public String DEGR_DETAI1  ;  //해외학위자유형1
    public String DEGR_SLAND1  ;  //해외학위자국가1
    public String DEGR_DETAI2  ;  //해외학위자유형2
    public String DEGR_SLAND2  ;  //해외학위자국가2
    public String DEGR_DETAI3  ;  //해외학위자유형3
    public String DEGR_SLAND3  ;  //해외학위자국가3
    public String RND_DETAI    ;  //R&D유형        
    public String RND_SLAND    ;  //R&D국가        
    public String FORE_NATIO   ;  //외국인국적     
    public String FORE_GESCH   ;  //외국인성별     
    public String FORE_STEXT   ;  //외국인학력     
    public String FORE_INFO    ;  //외국인비고     
    public String CHIN_NAME1   ;  //중국인사영역1  
    public String CHIN_BTEXT1  ;  //중국인사하위영역1
    public String CHIN_YEAR1   ;  //중국근무년수1    
    public String CHIN_NAME2   ;  //중국인사영역2    
    public String CHIN_BTEXT2  ;  //중국인사하위영역2
    public String CHIN_YEAR2   ;  //중국근무년수2    
    public String CHIN_NAME3   ;  //중국인사영역3    
    public String CHIN_BTEXT3  ;  //중국인사하위영역3
    public String CHIN_YEAR3   ;  //중국근무년수3    
    public String CHIN_NAME4   ;  //중국인사영역4    
    public String CHIN_BTEXT4  ;  //중국인사하위영역4
    public String CHIN_YEAR4   ;  //중국근무년수4    
    public String CHIN_NAME5   ;  //중국인사영역5    
    public String CHIN_BTEXT5  ;  //중국인사하위영역5
    public String CHIN_YEAR5   ;  //중국근무년수5    
    public String NCHIN_NAME1  ;  //중국외인사영역1  
    public String NCHIN_BTEXT1 ;  //중국외인사하위영역1
    public String NCHIN_YEAR1  ;  //중국외근무년수1    
    public String NCHIN_NAME2  ;  //중국외인사영역2    
    public String NCHIN_BTEXT2 ;  //중국외인사하위영역2
    public String NCHIN_YEAR2  ;  //중국외근무년수2    
    public String NCHIN_NAME3  ;  //중국외인사영역3    
    public String NCHIN_BTEXT3 ;  //중국외인사하위영역3
    public String NCHIN_YEAR3  ;  //중국외근무년수3    
    public String NCHIN_NAME4  ;  //중국외인사영역4    
    public String NCHIN_BTEXT4 ;  //중국외인사하위영역4
    public String NCHIN_YEAR4  ;  //중국외근무년수4    
    public String NCHIN_NAME5  ;  //중국외인사영역5    
    public String NCHIN_BTEXT5 ;  //중국외인사하위영역5
    public String NCHIN_YEAR5  ;  //중국외근무년수5    
}
    