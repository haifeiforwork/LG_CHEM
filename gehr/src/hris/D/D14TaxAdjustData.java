package hris.D ;

/**
 * D14TaxAdjustData.java
 * 연말정산 시뮬레이션 Data 및 결과내역조회 화면에 뿌려질 데이타
 * [RFC] ,ZHRP_RFC_READ_YEA_RESULT
 *
 * @author 김성일
 * @version 1.0, 2002/01/31
 * @version 1.0, 2013/02/06  /Y79 :_특별공제_주택저당차입금이자공제액 추가 특별공제 > 주택자금(주택임차원리금상환액·월세액·저당차입이자상환액) 의 금액에 추가
 * @version 1.0, 2014/01/16  CSR ID:C20140106_63914  한부모가족 /YSP ,특별공제 종합한도 초과액  /YAA
 * @version 3.0 2015/05/18 [CSR ID:2778743] 연말정산 내역조회 화면 수정
 * @version 4.0 2016/02/03 [CSR ID:2974323] 연말정산 내역조회 오픈요청
 *
 */
public class D14TaxAdjustData extends com.sns.jdf.EntityData {

    public String isUsableData = "";            // 데이터가 없으면 "NO" 로 세팅된다.
    public int  Count = 0;            // 데이터건수
    public String  ABART = "";    //  ABART : 국내 *, ''  해외  S 해외근무기간(1~6월), T 해외근무기간(7~12월) L 국내근무기간  항목

    public int notCngPerson = 0; //[CSR ID:2778743] 변경사항이 없는 인원 구분.

/*__________ 결과 내역 조회시 테이블에 있는 값___________________________*/

    public double _급여총액                   ; // 급여총액                     "/Y1A"
    public double _상여총액                   ; // 상여총액                     "/Y1B"
    public double _인정상여                   ; // 인정상여                     "/Y1C"
    public double _총급여                     ; // 총급여                       "/Y1T"
    public double _비과세소득_국외근로        ; // 비과세소득_국외근로          "/Y1G"
    public double _비과세소득_야간근로수당    ; // 비과세소득_야간근로수당 등   "/Y1E"
    public double _비과세소득_기타비과세      ; // 비과세소득_기타비과세        "/Y1F"
    public double _근로소득공제               ; // 근로소득공제                 "/Y2D"
    public double _과세대상근로소득금액       ; // 과세대상근로소득금액         "/Y2E"
    public double _기본공제_본인              ; // 기본공제_ 본인               "/Y3E"
    public double _기본공제_배우자            ; // 기본공제_배우자              "/Y3G"
    public double _기본공제_부양가족          ; // 기본공제_부양가족            "/Y3P"
    public double _추가공제_경로우대          ; // 추가공제_경로우대            "/Y3S"
	public double _추가공제_경로우대70	; // 추가공제_경로우대(70세이상)	 "/Y3U"
    public double _추가공제_장애인            ; // 추가공제_장애인              "/Y3T"
    public double _추가공제_부녀자            ; // 추가공제_부녀자              "/Y3V"
    public double _추가공제_출산입양        ; // 추가공제_출산입양          "/Y3W"  2008.12  20150126 제외
    public double _추가공제_자녀양육비        ; // 추가공제_자녀양육비          "/Y3X"			20150126 제외
    //public double _소수공제자추가공제         ; // 소수공제자추가공제           "/Y3Z"
    public double _세액공제_자녀_전         	 ; // 세액공제_자녀          	   "/Y3Z" + BTZNR = 77          [CSR ID:2778743]
    public double _세액공제_자녀         	 ; // 세액공제_자녀          	   "/Y3Z"  20150162 명칭변경
    //public double _특별공제_보험료            ; // 특별공제_보험료              "/Y4C"
    public double _특별공제_건강보험료            ; // 특별공제_건강보험료              "/Y4C" - 01
    public double _특별공제_고용보험료            ; // 특별공제_고용보험료              "/Y4C" - 02
    //public double _특별공제_의료비            ; // 특별공제_의료비              "/Y4H"		20150126 제외
    //public double _특별공제_교육비            ; // 특별공제_교육비              "/Y4M"		20150126 제외
    public double _특별공제_주택자금이자상환액; // 특별공제_주택자금이자상환액            "/Y54" 2008.12
    //public double _특별공제_월세액; // 특별공제_월세액            "/Y68" 2011.01
    public double _세액공제_월세액; // 특별공제_월세액            "/Y88" 20150126
    public double _특별공제_주택마련저축소득공제; // 특별공제_주택마련저축소득공제   "/Y5E" 2008.12
    public double _특별공제_주택저당차입금이자공제액; // 특별공제_주택마련저축소득공제   "/Y79" 2013.01

    //public double _특별공제_주택자금          ; // 특별공제_주택자금            "/Y5G"  20150126 제외

    public double _특별공제_주택임차차입금원리금상환액; // 특별공제_주택임차차입금원리금상환액   "/Y5L" 2008.12

    //public double _특별공제_기부금            ; // 특별공제_기부금              "/Y5S(기부금공제계산)" = "/Y5N(법정기부금)" + "/Y5R(지정기부금)"  20150126 제외
	//public double _특별공제_경조사비			;//특별공제_경조사비(혼인·장례·이사비)	 "/Y5U"   20150126 제외
    //public double _특별공제계                 ; // 특별공제계_또는 표준공제    "/Y5Z"
    public double _세액공제_표준세액공제_전             ; // 특별공제계_또는 표준공제    "/Y5Z" + BTZNR = 77          [CSR ID:2778743]
	public double _세액공제_표준세액공제                 ; // 특별공제계_또는 표준공제    "/Y5Z"   20150126 명칭수정
    public double _연금보험료공제            ; // 연금보험료공제   "/Y6A"
    //public double _차감소득금액              ; // 차감소득금액   "/Y6B" 20111.01							20150126 제외
    //public double _우리사주조합소득공제         ; // 우리사주조합 소득공제   "/Y6D" 20111.01		20150126 제외
    public double _소기업등소득공제         ; // 소기업.소상공인 공제부금 소득공제   "/Y7U" 20111.01	20150126 제외 [CSR ID:2974323] 연말정산 내역조회 오픈요청 20160203 추가
    //public double _연금보험료공제_국민     ; // 국민연금 연금보험료공제   "/Y6A - /Y6N" 20111.01   	20150126 제외
    public double _연금보험료공제_기타     ; // 기타연금 연금보험료공제   "/Y6N + /P16" 20111.01
    //public double _연금보험료공제_퇴직     ; // 퇴직연금소득공제              "/Y6S + /P21" 20111.01	20150126 제외
    public double _개인연금저축소득공제       ; // 개인연금저축소득공제         "/Y6I"
    //public double _연금저축소득공제           ; // 연금저축소득공제             "/Y6Q"							20150126 제외
    public double _투자조합출자등소득공제     ; // 투자조합출자등소득공제       "/Y6V"
    public double _신용카드공제_전           ; // 신용카드공제                 "/Y6M" + BTZNR = 77          [CSR ID:2778743]
    public double _신용카드공제               ; // 신용카드공제                 "/Y6M"
    public double _종합소득과세표준_전           ; // 종합소득과세표준             "/Y7B" + BTZNR = 77          [CSR ID:2778743]
    public double _종합소득과세표준           ; // 종합소득과세표준             "/Y7B"
    public double _산출세액_전                   ; // 산출세액                     "/Y7C" + BTZNR = 77          [CSR ID:2778743]
    public double _산출세액                   ; // 산출세액                     "/Y7C"
    public double _세액공제_근로소득_전          ; // 세액공제_근로소득            "/Y7E" + BTZNR = 77          [CSR ID:2778743]
    public double _세액공제_근로소득          ; // 세액공제_근로소득            "/Y7E"
    public double _세액공제_주택차입금        ; // 세액공제_주택차입금          "/Y7G"
    //public double _세액공제_근로자주식저축    ; // 세액공제_근로자주식저축      "/Y7I"			20150126 제외
    //public double _세액공제_외국납부          ; // 세액공제_외국납부            "/Y7M"			20150126 제외
    //public double _세액감면_소득세법정산      ; // 세액감면_소득세법정산        "/Y7Q"	20150126 제외
    //public double _세액감면_조세특례제한법    ; // 세액감면_조세특례제한법      "/Y7R"	20150126 제외
    //public double _납세조합공제    ; // 납세조합공제  "/Y7V" C20120214_50550  20120214	20150126 제외

    //public double _세액감면_장기주식형저축소득공제; // 세액감면_장기주식형저축소득공제      "/Y7W" 2008.12	20150126 제외

    public double _결정세액_갑근세_전        ; // 결정세액_갑근세              "/Y8I" + BTZNR = 77          [CSR ID:2778743]
    public double _결정세액_갑근세            ; // 결정세액_갑근세              "/Y8I"
    public double _결정세액_주민세_전        ; // 결정세액_주민세              "/Y8R" + BTZNR = 77          [CSR ID:2778743]
    public double _결정세액_주민세            ; // 결정세액_주민세              "/Y8R"
    public double _결정세액_농특세_전        ; // 결정세액_농특세              "/Y8S" + BTZNR = 77          [CSR ID:2778743]
    public double _결정세액_농특세            ; // 결정세액_농특세              "/Y8S"
    public double _기납부세액_갑근세          ; // 기납부세액_갑근세            "/Y9I"
    public double _기납부세액_주민세          ; // 기납부세액_주민세            "/Y9R"
    public double _기납부세액_농특세          ; // 기납부세액_농특세            "/Y9S"
    public double _차감징수세액_갑근세_전    ; // 차감징수세액_갑근세          "/YAI" + BTZNR = 77          [CSR ID:2778743]
    public double _차감징수세액_갑근세        ; // 차감징수세액_갑근세          "/YAI"
    public double _차감징수세액_주민세_전    ; // 차감징수세액_주민세          "/YAR" + BTZNR = 77          [CSR ID:2778743]
    public double _차감징수세액_주민세        ; // 차감징수세액_주민세          "/YAR"
    public double _차감징수세액_농특세_전    ; // 차감징수세액_농특세          "/YAS" + BTZNR = 77          [CSR ID:2778743]
    public double _차감징수세액_농특세        ; // 차감징수세액_농특세          "/YAS"

/*__________ 결과 내역 조회시 테이블에 없이 계산해서 넣어야 할 값___________________________*/

    //public double _장기증권저축               ; // 장기증권저축					20150126 제외
	//public double _정치기부금					; // 정치기부금						"/Y7N"
    public double _세액공제_정치기부금		; // 정치기부금    					20150126 명칭변경
    public double _세액공제합계               ; // 세액공제합계
    public double _결정세액합계_전               ; // 결정세액합계   [CSR ID:2778743]
    public double _결정세액합계               ; // 결정세액합계
    public double _기납부세액합계             ; // 기납부세액합계
    public double _차감징수세액합계_전           ; // 차감징수세액합계  [CSR ID:2778743]
    public double _차감징수세액합계           ; // 차감징수세액합계
    public double _차감징수세액합계_2014  ; //차감징수세액합계_재정산결과 [CSR ID:2778743] _차감징수세액합계 - _차감징수세액합계_전
//  2003.01.14. - 종전근무지 정보 추가 작업
    public double _비과세소득                 ; // 비과세소득 sum
    public double _전근무지_급여총액          ; // 전근무지 급여총액            "/P01"
    public double _전근무지_상여총액          ; // 전근무지 상여총액            "/P02"
    public double _전근무지_인정상여          ; // 전근무지 인정상여            "/P13"
    public double _전근무지_납부소득세        ; // 기납부세액에 합산            "/P03"
    public double _전근무지_납부주민세        ; // 기납부세액에 합산            "/P04"
    public double _전근무지_비과세해외소득    ; // 비과세소득에합산             "/P05"
    public double _전근무지_비과세초과근무    ; // 비과세소득에합산             "/P06"
    public double _전근무지_기타비과세대상    ; // 비과세소득에합산             "/P07"
    public double _전근무지_납부특별세        ; // 기납부세액에 합산            "/P14"
    //CSR ID:C20140106_63914
    public double _추가공제_한부모가족        ; //  한부모가족            "/YSP"
    public double _특별공제_종합한도_초과액        ; // 특별공제 종합한도 초과액           "/YAA"

    //@14 연말정산 조회 추가______________________________________________

    public double _특별공제_기부금        ; // 특별공제 기부금(이월분)           "/Y64"
    public double _그밖의_장기집합투자증권저축       ; // 그밖의 소득공제 장기집합투자증권저축           "/YC4"
    public double _세액공제_퇴직연금소득공제         ; // 세액공제 퇴직연금소득공제           "/Y82"
    public double _세액공제_연금저축소득공제_전         ; // 세액공제 연금저축소득공제           "/Y83" + BTZNR = 77          [CSR ID:2778743]
    public double _세액공제_연금저축소득공제         ; // 세액공제 연금저축소득공제           "/Y83"
    public double _세액공제_보장성보험료_전        	; // 세액공제 보장성보험료           "/Y84" + BTZNR = 77          [CSR ID:2778743]
    public double _세액공제_보장성보험료        	    ; // 세액공제 보장성보험료           "/Y84"
    public double _세액공제_의료비       			    ; // 의료비           "/Y85"
    public double _세액공제_교육비        				; // 세액공제 교육비           "/Y86"
    public double _세액공제_기부금        				; // 세액공제 기부금           "/Y87"

}
