package hris.D.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 *  D14TaxAdjustDetail_k_RFC.java
 *  (해외근무자)국내 연말정산 결과내역를 가져오는 RFC를 호출하는 Class
 *
 * @author 최 영호
 * @version 1.0, 2003/03/03
 */
public class D14TaxAdjustDetail_k_RFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_READ_YEA_RESULT3" ;

    /**
     * (해외근무자)국내 연말정산 결과내역를 가져오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param empNo java.lang.String 사원번호
     * @param GJAHR java.lang.String 회계년도
     * @exception com.sns.jdf.GeneralException
     */
    public Object detail( String empNo, String GJAHR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, GJAHR);
            excute(mConnection, function);
            Vector ret = getOutput( function );
            D14TaxAdjustData_k data = (D14TaxAdjustData_k)metchData(ret);
            // 연말정산내역조회기간이라도 데이터가 없을경우 flag를 단다.
            if(ret.size()==0){
                data.isUsableData = "NO";
            }
 
            return data;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사번
     * @param GJAHR java.lang.String 회계년도
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String GJAHR ) throws GeneralException {
        String fieldName1 = "PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "GJAHR";
        setField( function, fieldName2, GJAHR );
    }
// Export Return type이 Vector 인 경우 중 Vector의 Element type 가 com.sns.jdf.util.CodeEntity 일 경우 2
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "RTAB";      // RFC Export 구성요소 참조
        String codeField = "LGART";      // RFC Export table의 field 구성요소 중 CodeEntity의 "code" 가 될 Field Name 
        String valueField = "BETRG";     // RFC Export table의 field 구성요소 중 CodeEntity의 "value" 가 될 Field Name 
        return getCodeVector( function, tableName, codeField, valueField );
    }


    private Object metchData(Vector ret) throws GeneralException {

        D14TaxAdjustData_k retData = new D14TaxAdjustData_k();
        Logger.debug.println(this, ret.toString());

        double Data_Y6N =0; //임시계산
        double Data_P16 =0; //임시계산
        double Data_Y6S =0; //임시계산
        double Data_P21 =0; //임시계산
        for( int i = 0 ; i < ret.size() ; i++ ){
            CodeEntity data = (CodeEntity)ret.get(i);
            double d_value = 0;
            
            if(data.value.equals("")) {
              d_value = 0;
            } else { 
              d_value = Double.parseDouble(data.value) * 100.0;
            } // 100을 곱해서 변환해준다. 2002.05.03.

            if(data.code.equals("/Y1A")){     // 급여총액
                    retData._급여총액 = d_value; 
            } else if(data.code.equals("/Y1B")){    // 상여총액
                    retData._상여총액 = d_value; 
            } else if(data.code.equals("/Y1C")){    // 인정상여
                    retData._인정상여 = d_value; 
            } else if(data.code.equals("/Y1T")){    // 총급여
                    retData._총급여 = d_value; 
            } else if(data.code.equals("/Y1G")){    // 비과세소득-국외근로
                    retData._비과세소득_국외근로 = d_value; 
            } else if(data.code.equals("/Y1E")){    // 비과세소득-야간근로수당 등
                    retData._비과세소득_야간근로수당 = d_value; 
            } else if(data.code.equals("/Y1F")){    // 비과세소득-기타비과세
                    retData._비과세소득_기타비과세 = d_value; 
            } else if(data.code.equals("/Y2D")){    // 근로소득공제
                    retData._근로소득공제 = d_value; 
            } else if(data.code.equals("/Y2E")){    // 과세대상근로소득금액
                    retData._과세대상근로소득금액 = d_value; 
            } else if(data.code.equals("/Y3E")){    // 기본공제- 본인
                    retData._기본공제_본인 = d_value; 
            } else if(data.code.equals("/Y3G")){    // 기본공제-배우자
                    retData._기본공제_배우자 = d_value; 
            } else if(data.code.equals("/Y3P")){    // 기본공제-부양가족
                    retData._기본공제_부양가족 = d_value; 
            } else if(data.code.equals("/Y3S")){    // 추가공제-경로우대
                    retData._추가공제_경로우대 = d_value; 
            } else if(data.code.equals("/Y3U")){    // 추가공제-경로우대(70세이상)
                    retData._추가공제_경로우대70 = d_value; 
            } else if(data.code.equals("/Y3T")){    // 추가공제-장애인
                    retData._추가공제_장애인 = d_value; 
            } else if(data.code.equals("/Y3V")){    // 추가공제-부녀자
                    retData._추가공제_부녀자 = d_value; 
            } else if(data.code.equals("/Y3W")){    // 추가공제-출산입양추가공제 2008.12
                retData._추가공제_출산입양 = d_value; 
            } else if(data.code.equals("/Y3X")){    // 추가공제-자녀양육비
                    retData._추가공제_자녀양육비 = d_value; 
            } else if(data.code.equals("/Y3Z")){    // 소수공제자추가공제
                    retData._소수공제자추가공제 = d_value; 
            } else if(data.code.equals("/Y4C")){    // 특별공제-보험료
                    retData._특별공제_보험료 = d_value; 
            } else if(data.code.equals("/Y4H")){    // 특별공제-의료비
                    retData._특별공제_의료비 = d_value; 
            } else if(data.code.equals("/Y4M")){    // 특별공제-교육비
                    retData._특별공제_교육비 = d_value; 
            } else if(data.code.equals("/Y54")){    // 특별공제-주택자금이자상환액 2008.12
                retData._특별공제_주택자금이자상환액 = d_value; 
            } else if(data.code.equals("/Y5E")){    // 특별공제-주택마련저축소득공제 2008.12
                retData._특별공제_주택마련저축소득공제 = d_value; 
            } else if(data.code.equals("/Y5G")){    // 특별공제-주택자금
                    retData._특별공제_주택자금 = d_value; 
            } else if(data.code.equals("/Y5L")){    // 특별공제-주택임차차입금원리금상환액 2008.12
                retData._특별공제_주택임차차입금원리금상환액 = d_value; 
            } else if(data.code.equals("/Y5S")){    // 기부금공제계산
                    retData._특별공제_기부금 = d_value; 
            } else if(data.code.equals("/Y5U")){    // 경조사비(혼인·장례·이사비)
                    retData._특별공제_경조사비 = d_value; 
            } else if(data.code.equals("/Y5Z")){    // 특별공제계(또는 표준공제)
                    retData._특별공제계 = d_value; 
            } else if(data.code.equals("/Y6A")){    // 연금보험료공제
                    retData._연금보험료공제 = d_value; 
            } else if(data.code.equals("/Y6N")){    // Y6N
            	Data_Y6N += d_value; 
            } else if(data.code.equals("/P16")){    // P16
            	Data_P16 += d_value; 
            } else if(data.code.equals("/Y6S")){    // Y6S
            	Data_Y6S += d_value; 
            } else if(data.code.equals("/P21")){    // P21
            	Data_P21 += d_value;       
            } else if(data.code.equals("/Y68")){    // 특별공제_월세액    "/Y68" 2011.01 
                retData._특별공제_월세액 = d_value; 
            } else if(data.code.equals("/Y6I")){    // 개인연금저축소득공제
                    retData._개인연금저축소득공제 = d_value; 
            } else if(data.code.equals("/Y6Q")){    // 연금저축소득공제
                    retData._연금저축소득공제 = d_value; 
            } else if(data.code.equals("/Y6V")){    // 투자조합출자등소득공제
                    retData._투자조합출자등소득공제 = d_value; 
            } else if(data.code.equals("/Y6M")){    // 신용카드공제
                    retData._신용카드공제 = d_value; 
            } else if(data.code.equals("/Y7B")){    // 종합소득과세표준
                    retData._종합소득과세표준 = d_value; 
            } else if(data.code.equals("/Y7C")){    // 산출세액
                    retData._산출세액 = d_value; 
            } else if(data.code.equals("/Y7E")){    // 세액공제-근로소득
                    retData._세액공제_근로소득 = d_value; 
            } else if(data.code.equals("/Y7G")){    // 세액공제-주택차입금
                    retData._세액공제_주택차입금 = d_value; 
            } else if(data.code.equals("/Y7I")){    // 세액공제-근로자주식저축
                    retData._세액공제_근로자주식저축 = d_value; 
            } else if(data.code.equals("/Y7J")){    // 세액공제-장기증권저축
                    retData._장기증권저축 = d_value;
            } else if(data.code.equals("/Y7M")){    // 세액공제-외국납부
                    retData._세액공제_외국납부 = d_value; 
            } else if(data.code.equals("/Y7N")){    // 정치기부금
                    retData._정치기부금 = d_value;
            } else if(data.code.equals("/Y7Q")){    // 세액감면-소득세법정산
                    retData._세액감면_소득세법정산 = d_value; 
            } else if(data.code.equals("/Y7R")){    // 세액감면-조세특례제한법
                    retData._세액감면_조세특례제한법 = d_value; 
            } else if(data.code.equals("/Y7W")){    // 세액감면-장기주식펀드소득공제 2008.12
                retData._세액감면_장기주식형저축소득공제 = d_value; 
            } else if(data.code.equals("/Y8I")){    // 결정세액(갑근세)_원단위 절사
                    retData._결정세액_갑근세 = d_value;// - (d_value % 10); 
            } else if(data.code.equals("/Y8R")){    // 결정세액(주민세)_원단위 절사
                    retData._결정세액_주민세 = d_value;// - (d_value % 10); 
            } else if(data.code.equals("/Y8S")){    // 결정세액(농특세)_원단위 절사
                    retData._결정세액_농특세 = d_value;// - (d_value % 10); 
            } else if(data.code.equals("/Y9I")){    // 기납부세액(갑근세)
                    retData._기납부세액_갑근세 = d_value; 
            } else if(data.code.equals("/Y9R")){    // 기납부세액(주민세)
                    retData._기납부세액_주민세 = d_value; 
            } else if(data.code.equals("/Y9S")){    // 기납부세액(농특세)
                    retData._기납부세액_농특세 = d_value; 
            } else if(data.code.equals("1501")){    // 차감징수세액(갑근세)
                    retData._차감징수세액_갑근세 = d_value; 
            } else if(data.code.equals("1502")){    // 차감징수세액(주민세)
                    retData._차감징수세액_주민세 = d_value; 
            } else if(data.code.equals("/YAS")){    // 차감징수세액(농특세)
                    retData._차감징수세액_농특세 = d_value; 
//          2003.01.14. - 전근무지 정보가 추가된다. 
            } else if(data.code.equals("/P01")){    // 전근무지 내역에 급여항목에 보여줌 (별도)
                    retData._전근무지_급여총액 = d_value; 
            } else if(data.code.equals("/P02")){    // 전근무지 내역에 급여항목에 보여줌 (별도)
                    retData._전근무지_상여총액 = d_value; 
            } else if(data.code.equals("/P13")){    // 전근무지 내역에 인정상여 항목으로 (별도) 
                    retData._전근무지_인정상여 = d_value;
            } else if(data.code.equals("/P03")){    // 기납부세액에 합산
                    retData._전근무지_납부소득세 = d_value;
            } else if(data.code.equals("/P04")){    // 기납부세액에 합산
                    retData._전근무지_납부주민세 = d_value;
            } else if(data.code.equals("/P05")){    // 비과세소득에합산
                    retData._전근무지_비과세해외소득 = d_value;
            } else if(data.code.equals("/P06")){    // 비과세소득에합산
                    retData._전근무지_비과세초과근무 = d_value;
            } else if(data.code.equals("/P07")){    // 비과세소득에합산
                    retData._전근무지_기타비과세대상 = d_value;
            } else if(data.code.equals("/P14")){    // 기납부세액에 합산
                    retData._전근무지_납부특별세 = d_value;
            }
        }
        // 현근무지 급여,상여정보를 다시 구한다.
        retData._급여총액 -= retData._전근무지_급여총액;
        retData._상여총액 -= retData._전근무지_상여총액;
        retData._인정상여 -= retData._전근무지_인정상여;
        
        // 비과세소득 합계 - 국내분은 _비과세소득_국외근로를 제외한다. (2003.03.11)
        double hap7  = retData._비과세소득_야간근로수당;
               hap7 += retData._비과세소득_기타비과세  ;
               hap7 += retData._전근무지_비과세해외소득;
               hap7 += retData._전근무지_비과세초과근무;
               hap7 += retData._전근무지_기타비과세대상;
        
        retData._비과세소득 = hap7;
        
        // 특별공제계(또는 표준공제) 도 계산 필요
        double hap  = retData._특별공제_보험료  ;
               hap += retData._특별공제_의료비  ;
               hap += retData._특별공제_교육비  ;
               hap += retData._특별공제_주택자금;
               hap += retData._특별공제_기부금  ;
			   hap += retData._특별공제_경조사비  ;
			   hap += retData._특별공제_월세액; //2011.01

        retData._특별공제계 = ( (retData._특별공제계 > hap) ? retData._특별공제계 : hap );
        
        // 차감소득금액 계산
        double hap2  = retData._기본공제_본인       ;
               hap2 += retData._기본공제_배우자     ;
               hap2 += retData._기본공제_부양가족   ;
               hap2 += retData._추가공제_경로우대   ;
			   hap2 += retData._추가공제_경로우대70	;
               hap2 += retData._추가공제_장애인     ;
               hap2 += retData._추가공제_부녀자     ;
               hap2 += retData._추가공제_자녀양육비 ;
               hap2 += retData._소수공제자추가공제  ;
               hap2 += retData._특별공제계          ;
               hap2 += retData._연금보험료공제      ;

        retData._차감소득금액 = retData._과세대상근로소득금액 - hap2 ;
        
        // 특별공제_기부금 계산 
//        retData._특별공제_기부금 = retData._특별공제_기부금1 + retData._특별공제_기부금2 ;
  
        // 세액공제합계 계산
        double hap3  = retData._세액공제_근로소득       ;
               hap3 += retData._세액공제_주택차입금     ;
               hap3 += retData._세액공제_근로자주식저축 ;
               hap3 += retData._장기증권저축            ;
			   hap3 += retData._정치기부금					;
               hap3 += retData._세액공제_외국납부       ;

        retData._세액공제합계 = hap3 ;

        // 결정세액합계 계산       
        double hap4  = retData._결정세액_갑근세 ;
               hap4 += retData._결정세액_주민세 ;
               hap4 += retData._결정세액_농특세 ;

        retData._결정세액합계 = hap4 ;

        // 기납부세액합계 계산
//        retData._기납부세액_갑근세 += retData._전근무지_납부소득세;
//        retData._기납부세액_주민세 += retData._전근무지_납부주민세;
//        retData._기납부세액_농특세 += retData._전근무지_납부특별세;
        double hap5  = retData._기납부세액_갑근세 ;
               hap5 += retData._기납부세액_주민세 ;
               hap5 += retData._기납부세액_농특세 ;

        retData._기납부세액합계 = hap5 ;

        // 차감징수세액합계 계산   
        double hap6  = retData._차감징수세액_갑근세 ;
               hap6 += retData._차감징수세액_주민세 ;
               hap6 += retData._차감징수세액_농특세 ;

        retData._차감징수세액합계 = hap6 ;

        retData._연금보험료공제_국민 = retData._연금보험료공제 - Data_Y6N; //   "/Y6A - /Y6N" 20111.01
        retData._연금보험료공제_기타 = Data_Y6N + Data_P16;                   //   "/Y6N + /P16" 20111.01
        retData._연금보험료공제_퇴직 = Data_Y6S + Data_P21;                   //   "/Y6S + /P21" 20111.01

Logger.debug.println(this, retData.toString());
        return retData ;
    }
}