package hris.A.A18Deduct ;

/**
 * A18CertiPrint01Data.java
 * 근로소득원천징수영수증:T_RESULT
 * [RFC] ,ZHRP_RFC_READ_YEA_RESULT_PRINT
 * 
 * @author  김도신 
 * @version 1.0, 2005/09/29
 */
public class A18CertiPrint01Data extends com.sns.jdf.EntityData {

    public double _급여총액                   ; // "/Y1A"
    public double _상여총액                   ; // "/Y1B"
    public double _인정상여                   ; // "/Y1C"
    public double _주식매수선택권행사이익 ; // "/Y18" 09.02.03 add   
    public double _우리사주조합인출금 ; // "/Y22" 10.02.04 add   
    public double _납세조합공제 ; // "/Y7V" 10.02.04 add   

    public double _비과세소득_연구활동비      ; // "/Y1K"  09.02.03 add
    public double _비과세소득_출산보육수당      ; // "/Y16"  09.02.03 add
    public double _비과세소득_외국인근로자      ; // "/Y15"  09.02.03 add
     
    public double _비과세소득_국외근로        ; // "/Y1G"
    public double _비과세소득_야간근로수당    ; // "/Y1E"
    public double _비과세소득_기타비과세      ; // "/Y1F"
    public double _비과세소득_합계            ; // 비과세소득 합계

    public double _총급여                     ; // "/Y1T"
    public double _근로소득공제               ; // "/Y2D"
    public double _근로소득금액               ; // "/Y2E"
// 종합소득금액-기본공제
    public double _기본공제_본인              ; // "/Y3E"
    public double _기본공제_배우자            ; // "/Y3G"
    public double _기본공제_부양가족          ; // "/Y3P"
// 종합소득금액-추가공제
    public double _추가공제_경로우대          ; // "/Y3S" + "/Y3U"
    public double _추가공제_장애인            ; // "/Y3T"
    public double _추가공제_부녀자            ; // "/Y3V"
    public double _추가공제_자녀양육비        ; // "/Y3X"
    public double _추가공제_출산입양자        ; // "/Y3W"  09.02.03 add
// 소수공제자추가공제
    public double _소수공제자추가공제         ; // "/Y3Z"
// 연금보험료공제
    public double _연금보험료공제             ; // "/Y6A"
    public double _국민연금보험료공제        ; // "=/Y6A - /Y6N"  09.02.03 add
    public double _기타연금보험료공제        ; // "/Y6N"  09.02.03 add
    public double _퇴직연금소득공제           ; // "/Y6S"  09.02.03 add
// 종합소득금액-특별공제
    public double _특별공제_보험료            ; // "/Y4C"
    public double _특별공제_의료비            ; // "/Y4H"
    public double _특별공제_교육비            ; // "/Y4M"
    public double _특별공제_주택자금          ; // "/Y5G"
    public double _특별공제_장기주택저당차입금이자상환액; // "/Y54"  09.02.03 add
    public double _특별공제_주택임차차입금원리금상환액   ; // "/Y5L"  09.02.03 add
    public double _특별공제_기부금            ; // "/Y5S(기부금공제계산)" = "/Y5N(법정기부금)" + "/Y5R(지정기부금)"
    public double _특별공제_혼인이사장례비    ; // "/Y5U"
    public double _특별공제_계                ; // 특별공제 합계
// 표준공제
    public double _표준공제                   ; // "/Y5Z"
// 차감소득금액
    public double _차감소득금액               ; // _근로소득금액 - 종합소득금액 합계
// 조특소득공제
    public double _Y6B       ; // "/Y6B"
    public double _개인연금저축소득공제       ; // "/Y6I"
    public double _연금저축소득공제           ; // "/Y6Q"
    public double _투자조합출자등소득공제     ; // "/Y6V"
    public double _신용카드공제               ; // "/Y6M"
    public double _소상공인공제부금소득공제; // "/Y7U"  09.02.03 add
    public double _주택마련저축소득공제; // "/Y5E"  09.02.03 add
    public double _장기주식형저축소득공제; // "/Y7W"  09.02.03 add
    public double _그밖의소득공제계; // "/Y7W"  09.02.03 add
    
// 종합소득과세표준
    public double _종합소득과세표준           ; // "/Y7B"
// 산출세액
    public double _산출세액                   ; // "/Y7C"
// 세액감면
    public double _세액감면_소득세법정산      ; // "/Y7Q"
    public double _세액감면_조세특례제한법    ; // "/Y7R"
    public double _세액감면_감면세액계        ; // 세액감면 합계
// 세액공제
    public double _세액공제_근로소득          ; // "/Y7E"
    public double _세액공제_주택차입금        ; // "/Y7G"
    public double _세액공제_근로자주식저축    ; // "/Y7I"
    public double _세액공제_외국납부          ; // "/Y7M"
    public double _세액공제_기부정치자금   		; // "/Y7N"
    public double _세액공제_세액공제계        ; // 세액공제 합계
    
    public double _결정세액_갑근세            ; // "/Y8I"
    public double _결정세액_주민세            ; // "/Y8R"
    public double _결정세액_농특세            ; // "/Y8S"
    public double _결정세액_합계              ; // 결정세액 합계    
    public double _기납부세액_갑근세          ; // "/Y9I"
    public double _기납부세액_주민세          ; // "/Y9R"
    public double _기납부세액_농특세          ; // "/Y9S"
    public double _기납부세액_합계            ; // 기납부세액 합계  

    public double _종전_소득세          ; // "/P03"  09.02.03 add    
    public double _종전_주민세          ; // "/P04" 09.02.03 add     
    public double _종전_합계            ; // 기납부세액 합계    09.02.03 add
    
    
    public double _차감징수세액_갑근세        ; // "/YAI"
    public double _차감징수세액_주민세        ; // "/YAR"
    public double _차감징수세액_농특세        ; // "/YAS"
    public double _차감징수세액_합계          ; // 차감징수세액 합계
// 건강보험, 고용보험
    public double _건강보험                   ; // "/Y42"
    public double _고용보험                   ; // "/Y44"
}
