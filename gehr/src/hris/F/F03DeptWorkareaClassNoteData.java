/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 근무지별/직급별 인원현황                                    */
/*   Program ID   : F03DeptWorkareaClassNoteData                                */
/*   Description  : 근무지별/직급별 인원현황 조회를 위한 DATA 파일              */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-02 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F;   
 
/**
 * F01DeptPositionClassNoteData
 *  근무지별/직급별 인원현황 내용을 담는 데이터 
 *  
 * @author 유용원
 * @version 1.0,  
 */

public class F03DeptWorkareaClassNoteData extends com.sns.jdf.EntityData {
    public String WERKS    ;    //인사영역             
    public String PBTXT    ;    //인사영역텍스트          
    public String BTRTL    ;    //인사하위영역        
    public String BTEXT    ;    //인사하위영역 텍스트
    public String F1       ;    //인원현황1         
    public String TITLACD1 ;    //타이틀A 코드      
    public String TITLBCD1 ;    //타이틀B 코드      
    public String F2       ;    //인원현황1         
    public String TITLACD2 ;    //타이틀A 코드      
    public String TITLBCD2 ;    //타이틀B 코드      
    public String F3       ;    //인원현황1         
    public String TITLACD3 ;    //타이틀A 코드      
    public String TITLBCD3 ;    //타이틀B 코드      
    public String F4       ;    //인원현황1         
    public String TITLACD4 ;    //타이틀A 코드      
    public String TITLBCD4 ;    //타이틀B 코드      
    public String F5       ;    //인원현황1         
    public String TITLACD5 ;    //타이틀A 코드      
    public String TITLBCD5 ;    //타이틀B 코드      
    public String F6       ;    //인원현황1         
    public String TITLACD6 ;    //타이틀A 코드      
    public String TITLBCD6 ;    //타이틀B 코드      
    public String F7       ;    //인원현황1         
    public String TITLACD7 ;    //타이틀A 코드      
    public String TITLBCD7 ;    //타이틀B 코드      
    public String F8       ;    //인원현황1         
    public String TITLACD8 ;    //타이틀A 코드      
    public String TITLBCD8 ;    //타이틀B 코드      
    public String F9       ;    //인원현황1         
    public String TITLACD9 ;    //타이틀A 코드      
    public String TITLBCD9 ;    //타이틀B 코드      
    public String F10      ;    //인원현황1         
    public String TITLACD10;    //타이틀A 코드      
    public String TITLBCD10;    //타이틀B 코드      
    public String F11      ;    //인원현황1         
    public String TITLACD11;    //타이틀A 코드      
    public String TITLBCD11;    //타이틀B 코드      
    public String F12      ;    //인원현황1         
    public String TITLACD12;    //타이틀A 코드      
    public String TITLBCD12;    //타이틀B 코드      
    public String F13      ;    //인원현황1         
    public String TITLACD13;    //타이틀A 코드      
    public String TITLBCD13;    //타이틀B 코드      
    public String F14      ;    //인원현황1         
    public String TITLACD14;    //타이틀A 코드      
    public String TITLBCD14;    //타이틀B 코드      
    public String F15      ;    //인원현황1         
    public String TITLACD15;    //타이틀A 코드      
    public String TITLBCD15;    //타이틀B 코드      
    public String F16      ;    //인원현황1         
    public String TITLACD16;    //타이틀A 코드      
    public String TITLBCD16;    //타이틀B 코드      
    public String F17      ;    //인원현황1         
    public String TITLACD17;    //타이틀A 코드      
    public String TITLBCD17;    //타이틀B 코드      
    public String F18      ;    //인원현황1         
    public String TITLACD18;    //타이틀A 코드      
    public String TITLBCD18;    //타이틀B 코드      
    public String F19      ;    //인원현황1         
    public String TITLACD19;    //타이틀A 코드      
    public String TITLBCD19;    //타이틀B 코드      
    public String F20      ;    //인원현황1         
    public String TITLACD20;    //타이틀A 코드      
    public String TITLBCD20;    //타이틀B 코드      
    public String F21      ;    //인원현황1         
    public String TITLACD21;    //타이틀A 코드      
    public String TITLBCD21;    //타이틀B 코드      
    public String F22      ;    //인원현황1         
    public String TITLACD22;    //타이틀A 코드      
    public String TITLBCD22;    //타이틀B 코드      
    public String F23      ;    //인원현황1         
    public String TITLACD23;    //타이틀A 코드      
    public String TITLBCD23;    //타이틀B 코드      
    public String F24      ;    //인원현황1         
    public String TITLACD24;    //타이틀A 코드      
    public String TITLBCD24;    //타이틀B 코드      
    public String F25      ;    //인원현황1         
    public String TITLACD25;    //타이틀A 코드      
    public String TITLBCD25;    //타이틀B 코드      
    public String F26      ;    //인원현황1         
    public String TITLACD26;    //타이틀A 코드      
    public String TITLBCD26;    //타이틀B 코드      
    public String F27      ;    //인원현황1         
    public String TITLACD27;    //타이틀A 코드      
    public String TITLBCD27;    //타이틀B 코드      
    public String F28      ;    //인원현황1         
    public String TITLACD28;    //타이틀A 코드      
    public String TITLBCD28;    //타이틀B 코드      
    public String F29      ;    //인원현황1         
    public String TITLACD29;    //타이틀A 코드      
    public String TITLBCD29;    //타이틀B 코드      
    public String F30      ;    //인원현황1         
    public String TITLACD30;    //타이틀A 코드      
    public String TITLBCD30;    //타이틀B 코드      
    public String F31      ;    //인원현황1         
    public String TITLACD31;    //타이틀A 코드      
    public String TITLBCD31;    //타이틀B 코드      
    public String F32      ;    //인원현황1         
    public String TITLACD32;    //타이틀A 코드      
    public String TITLBCD32;    //타이틀B 코드      
    public String F33      ;    //인원현황1         
    public String TITLACD33;    //타이틀A 코드      
    public String TITLBCD33;    //타이틀B 코드      
    public String F34      ;    //인원현황1         
    public String TITLACD34;    //타이틀A 코드      
    public String TITLBCD34;    //타이틀B 코드      
    public String F35      ;    //인원현황1         
    public String TITLACD35;    //타이틀A 코드      
    public String TITLBCD35;    //타이틀B 코드      
    public String F36      ;    //인원현황1         
    public String TITLACD36;    //타이틀A 코드      
    public String TITLBCD36;    //타이틀B 코드      
    public String F37      ;    //인원현황1         
    public String TITLACD37;    //타이틀A 코드      
    public String TITLBCD37;    //타이틀B 코드      
    public String F38      ;    //인원현황1         
    public String TITLACD38;    //타이틀A 코드      
    public String TITLBCD38;    //타이틀B 코드      
    public String F39      ;    //인원현황1         
    public String TITLACD39;    //타이틀A 코드      
    public String TITLBCD39;    //타이틀B 코드      
    public String F40      ;    //인원현황1         
    public String TITLACD40;    //타이틀A 코드      
    public String TITLBCD40;    //타이틀B 코드      
    public String F41      ;    //인원현황1         
    public String TITLACD41;    //타이틀A 코드      
    public String TITLBCD41;    //타이틀B 코드      
    public String F42      ;    //인원현황1         
    public String TITLACD42;    //타이틀A 코드      
    public String TITLBCD42;    //타이틀B 코드      
    public String F43      ;    //인원현황1         
    public String TITLACD43;    //타이틀A 코드      
    public String TITLBCD43;    //타이틀B 코드      
    public String F44      ;    //인원현황1         
    public String TITLACD44;    //타이틀A 코드      
    public String TITLBCD44;    //타이틀B 코드      
    public String F45      ;    //인원현황1         
    public String TITLACD45;    //타이틀A 코드      
    public String TITLBCD45;    //타이틀B 코드      
    public String F46      ;    //인원현황1         
    public String TITLACD46;    //타이틀A 코드      
    public String TITLBCD46;    //타이틀B 코드      
    public String F47      ;    //인원현황1         
    public String TITLACD47;    //타이틀A 코드      
    public String TITLBCD47;    //타이틀B 코드      
    public String F48      ;    //인원현황1         
    public String TITLACD48;    //타이틀A 코드      
    public String TITLBCD48;    //타이틀B 코드      
    public String F49      ;    //인원현황1         
    public String TITLACD49;    //타이틀A 코드      
    public String TITLBCD49;    //타이틀B 코드      
    public String F50      ;    //인원현황1         
    public String TITLACD50;    //타이틀A 코드      
    public String TITLBCD50;    //타이틀B 코드 
    public String F51      ;    //인원현황1         
    public String TITLACD51;    //타이틀A 코드      
    public String TITLBCD51;    //타이틀B 코드      
    public String F52      ;    //인원현황1         
    public String TITLACD52;    //타이틀A 코드      
    public String TITLBCD52;    //타이틀B 코드      
    public String F53      ;    //인원현황1         
    public String TITLACD53;    //타이틀A 코드      
    public String TITLBCD53;    //타이틀B 코드      
    public String F54      ;    //인원현황1         
    public String TITLACD54;    //타이틀A 코드      
    public String TITLBCD54;    //타이틀B 코드      
    public String F55      ;    //인원현황1         
    public String TITLACD55;    //타이틀A 코드      
    public String TITLBCD55;    //타이틀B 코드      
    public String F56      ;    //인원현황1         
    public String TITLACD56;    //타이틀A 코드      
    public String TITLBCD56;    //타이틀B 코드      
    public String F57      ;    //인원현황1         
    public String TITLACD57;    //타이틀A 코드      
    public String TITLBCD57;    //타이틀B 코드      
    public String F58      ;    //인원현황1         
    public String TITLACD58;    //타이틀A 코드      
    public String TITLBCD58;    //타이틀B 코드      
    public String F59      ;    //인원현황1         
    public String TITLACD59;    //타이틀A 코드      
    public String TITLBCD59;    //타이틀B 코드      
    public String F60      ;    //인원현황1         
    public String TITLACD60;    //타이틀A 코드      
    public String TITLBCD60;    //타이틀B 코드  
    public String F61      ;    //인원현황1         
    public String TITLACD61;    //타이틀A 코드      
    public String TITLBCD61;    //타이틀B 코드      
    public String F62      ;    //인원현황1         
    public String TITLACD62;    //타이틀A 코드      
    public String TITLBCD62;    //타이틀B 코드      
    public String F63      ;    //인원현황1         
    public String TITLACD63;    //타이틀A 코드      
    public String TITLBCD63;    //타이틀B 코드      
    public String F64      ;    //인원현황1         
    public String TITLACD64;    //타이틀A 코드      
    public String TITLBCD64;    //타이틀B 코드      
    public String F65      ;    //인원현황1         
    public String TITLACD65;    //타이틀A 코드      
    public String TITLBCD65;    //타이틀B 코드      
    public String F66      ;    //인원현황1         
    public String TITLACD66;    //타이틀A 코드      
    public String TITLBCD66;    //타이틀B 코드      
    public String F67      ;    //인원현황1         
    public String TITLACD67;    //타이틀A 코드      
    public String TITLBCD67;    //타이틀B 코드      
    public String F68      ;    //인원현황1         
    public String TITLACD68;    //타이틀A 코드      
    public String TITLBCD68;    //타이틀B 코드      
    public String F69      ;    //인원현황1         
    public String TITLACD69;    //타이틀A 코드      
    public String TITLBCD69;    //타이틀B 코드      
    public String F70      ;    //인원현황1         
    public String TITLACD70;    //타이틀A 코드      
    public String TITLBCD70;    //타이틀B 코드     
}
