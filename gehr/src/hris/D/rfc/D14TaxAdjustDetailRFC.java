package hris.D.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;
import hris.D.D05Mpay.D05MpayDetailData5;

/**
 *  D14TaxAdjustDetailRFC.java
 *  연말정산 결과내역를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/28  2013/02/06  /Y79 :특별공제_저당차입이자상환액 추가 특별공제 > 주택자금(주택임차원리금상환액·월세액·저당차입이자상환액) 의 금액에 추가
 * @version 2.0 2014/01/17  C20140106_63914 ABART : 국내 *, ''  해외  S 해외근무기간(1~6월), T 해외근무기간(7~12월) L 국내근무기간  항목 추가되어 구조변경
 * @version 3.0 2015/05/18 [CSR ID:2778743] 연말정산 내역조회 화면 수정
 * @version 4.0 2016/02/03 [CSR ID:2974323] 연말정산 내역조회 오픈요청 20160203 추가

 */
public class D14TaxAdjustDetailRFC extends SAPWrap {

    private  static String functionName = "ZSOLYR_RFC_READ_YEA_RESULT" ;

    /**
     * 연말정산 결과내역를 가져오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param empNo java.lang.String 사원번호
     * @param GJAHR java.lang.String 회계년도
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String empNo, String GJAHR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, GJAHR);
            excute(mConnection, function);

            //C20140106_63914 ABART : 국내 *, ''  해외  S 해외근무기간(1~6월), T 해외근무기간(7~12월) L 국내근무기간

            Vector ret = getOutput( function  );
            //Logger.sap.println(this, "detail ret : "+ret.toString());
            D14TaxAdjustData data = (D14TaxAdjustData)metchData(ret,"*" ); //국내 *, ''
            D14TaxAdjustData data1 = (D14TaxAdjustData)metchData(ret,"S" ); //S 해외근무기간(1~6월)
            D14TaxAdjustData data2 = (D14TaxAdjustData)metchData(ret,"T" ); // T 해외근무기간(7~12월)
            D14TaxAdjustData data3 = (D14TaxAdjustData)metchData(ret,"L" ); // L 국내근무기간


            // 연말정산내역조회기간이라도 데이터가 없을경우 flag를 단다.
            if(ret.size()==0){
                data.isUsableData = "NO";
            }
            Vector retvt = new Vector();
            retvt.addElement(data);
            retvt.addElement(data1);
            retvt.addElement(data2);
            retvt.addElement(data3);

           // Logger.sap.println(this, "detail retvt : "+retvt.toString());

            return retvt;
            //return data;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public String GetMessage( String empNo, String GJAHR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, GJAHR);
            excute(mConnection, function);
            String E_MESSAGE = getOutput1( function );

            return E_MESSAGE;
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
    private Vector getOutput(JCO.Function function ) throws GeneralException {
        String tableName = "RTAB";      // RFC Export 구성요소 참조
        String codeField = "LGART";      // 임금 유형임금 유형
        String valueField = "BETRG";     // HR 급여관리: 금액
        String gubnField = "ABART";     // 급여 계산 규칙에 대한 사원 하위 그룹 그루핑
        String subCodeField = "CNTR1"; //건강보험료, 고용보험료 구분을 위함(/Y4C-01,/Y4C-02) //@2014 연말정산 추가
        String subCodeField2 = "V0ZNR"; //기부금 계산 조건에 필요 ( 해당 값이 01이 아닌 것의 sum) //@2014 연말정산 추가
        String reTax2014 = "BTZNR";//2014연말정산 재정산


        Vector retvt = new Vector();
        try{
            JCO.Table table = function.getTableParameterList().getTable(tableName);

            for (int i = 0; i < table.getNumRows(); i++) {
                table.setRow(i);

                D14TaxAdjustCodeData ret = new D14TaxAdjustCodeData();

                ret.code = table.getString(codeField);
                ret.value = table.getString(valueField);
                ret.gubn = table.getString(gubnField);
                ret.subCode = table.getString(subCodeField); //@2014 연말정산 추가
                ret.subCode2 = table.getString(subCodeField2); //@2014 연말정산 추가
                ret.reTax2014 = table.getString(reTax2014);//2014연말정산 재정산


                //Logger.debug.println(this, ret.toString());
                DataUtil.fixNullAndTrim( ret );
                retvt.addElement(ret);
            }


            //Logger.debug.println(this, "************getCodeVector()  ...끝 ********* tableName : "+tableName );
        } catch ( Exception ex ){
            Logger.debug.println(this, "getCodeVector( JCO.Function function, String tableName, String codeField, String valueField )에서 예외발생 " );
            throw new GeneralException(ex);
        }

        return retvt;


       // return getTable(entityName, function, tableName);
        //return getCodeVector( function, tableName, codeField, valueField );
    }

    private Object metchData(Vector ret,String gubn) throws GeneralException {

        D14TaxAdjustData retData = new D14TaxAdjustData();

        double Data_Y6N =0; //임시계산
        double Data_P16 =0; //임시계산
        //double Data_Y6S =0; //임시계산
        //double Data_P21 =0; //임시계산
        retData.Count =0;
        int notChangePerson = 0;

        //[CSR ID:2778743] 변경대상 아닌 인원 구분용
        for( int i = 0 ; i < ret.size() ; i++ ){

        	D14TaxAdjustCodeData data = (D14TaxAdjustCodeData)ret.get(i);
        	if("77".equals(data.reTax2014)){
        		notChangePerson += 1;
        	}
        }
        retData.notCngPerson = notChangePerson;


        String tmpABART =null;//급여 계산 규칙에 대한 사원 하위 그룹 그루핑
        for( int i = 0 ; i < ret.size() ; i++ ){

        	D14TaxAdjustCodeData data = (D14TaxAdjustCodeData)ret.get(i);
        	if (gubn.equals("*")) { //국내
	        	if (data.gubn.equals("*")|| data.gubn.equals("")|| data.gubn==null){
	        		//tmpABART=data.gubn;
	        		tmpABART="*";
	        	}else{
	        		tmpABART="NA";
	        	}
        	}else{
        		tmpABART = data.gubn;
	        }
            //Logger.debug.println(this,"1 metchData: gubn "+ gubn+"tmpABART:"+tmpABART );
        	if (gubn.equals(tmpABART)) {

                retData.ABART =data.gubn;
        		double d_value = 0;

		            if(data.value.equals("")) {
		              d_value = 0;
		            } else {
		              d_value = Double.parseDouble(data.value) * 100.0;
		            } // 100을 곱해서 변환해준다. 2002.05.03.

	        		retData.Count = retData.Count+1; // C20140106_63914

	         if(!"77".equals(data.reTax2014)){
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
		            } else if(data.code.equals("/Y3W")){    // 추가공제-출산입양추가공제 2008.12  20150126 제외 [CSR ID:2778743]추가
		                retData._추가공제_출산입양 = d_value;
		            } else if(data.code.equals("/Y3X")){    // 추가공제-자녀양육비						 20150126 제외 [CSR ID:2778743]추가
		                    retData._추가공제_자녀양육비 = d_value;
		            } else if(data.code.equals("/Y3Z")){    // 소수공제자추가공제	 => 세액공제_자녀 20150126 변경
	                    retData._세액공제_자녀 = d_value;
		            } else if(data.code.equals("/Y4C")&&data.subCode.equals("01")){    // 특별공제-보험료
		                    retData._특별공제_건강보험료 = d_value;
		            } else if(data.code.equals("/Y4C")&&data.subCode.equals("02")){    // 특별공제-보험료
	                    retData._특별공제_고용보험료 = d_value;
		            //} else if(data.code.equals("/Y4H")){    // 특별공제-의료비				20150126 제외
		            //        retData._특별공제_의료비 = d_value;
		            //} else if(data.code.equals("/Y4M")){    // 특별공제-교육비				20150126 제외
		            //        retData._특별공제_교육비 = d_value;
		            } else if(data.code.equals("/Y54")){    // 특별공제-주택자금이자상환액 2008.12
		                retData._특별공제_주택자금이자상환액 = d_value;
		            } else if(data.code.equals("/Y5E")){    // 특별공제-주택마련저축소득공제 2008.12
		                retData._특별공제_주택마련저축소득공제 = d_value;
		            //} else if(data.code.equals("/Y5G")){    // 특별공제-주택자금
		            //    retData._특별공제_주택자금 = d_value;
		            } else if(data.code.equals("/Y5L")){    // 특별공제-주택임차차입금원리금상환액 2008.12
		                retData._특별공제_주택임차차입금원리금상환액 = d_value;
		            }else if(data.code.equals("/Y5S")&&!data.subCode2.equals("01")){    // 기부금공제계산				20150126 코드 변경  Y5S  && subcode2가 01이 아닌 것의 sum
		                    retData._특별공제_기부금 += d_value;
		            //} else if(data.code.equals("/Y5U")){    // 경조사비(혼인·장례·이사비) 20150126 제외
		            //        retData._특별공제_경조사비 = d_value;
		            } else if(data.code.equals("/Y5Z")){    // 특별공제계(또는 표준공제)
	                    retData._세액공제_표준세액공제 = d_value;
		            } else if(data.code.equals("/Y6A")){    // 연금보험료공제
		                    retData._연금보험료공제 = d_value;
		            } else if(data.code.equals("/Y6N")){    // Y6N 20111.01
		            	Data_Y6N = d_value;
		            	retData._연금보험료공제_기타 = d_value;
		            //} else if(data.code.equals("/P16")){    // P16       20150126 제외
		            //	Data_P16 = d_value;
		            //} else if(data.code.equals("/Y6S")){    // Y6S      20150126 제외
		            	//Data_Y6S = d_value;
		            //    retData._연금보험료공제_퇴직 = d_value;
		            //} else if(data.code.equals("/P21")){    // P21
		            	//Data_P21 = d_value;
		            //} else if(data.code.equals("/Y6B")){    // _차감소득금액    "/Y6B" 2011.01   20150126제외
		            //    retData._차감소득금액 = d_value;
		            //} else if(data.code.equals("/Y6D")){     // 우리사주조합 소득공제   "/Y6D" 20111.01   20150126제외
		            //    retData._우리사주조합소득공제 = d_value;
		            } else if(data.code.equals("/Y88")){    // 특별공제_월세액    "/Y88" 2011.01
		                retData._세액공제_월세액 = d_value;
		            } else if(data.code.equals("/Y79")){    // 특별공제_월세액    "/Y79" 2013.01
		                retData._특별공제_주택저당차입금이자공제액 = d_value;
		            } else if(data.code.equals("/Y6I")){    // 개인연금저축소득공제
		                retData._개인연금저축소득공제 = d_value;
		            //} else if(data.code.equals("/Y6Q")){    // 연금저축소득공제						20150126제외
		            //        retData._연금저축소득공제 = d_value;
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
		            //} else if(data.code.equals("/Y7I")){    // 세액공제-근로자주식저축   20150126 제외
		            //        retData._세액공제_근로자주식저축 = d_value;
		            //} else if(data.code.equals("/Y7J")){    // 세액공제-장기증권저축	 20150126 제외
		            //        retData._장기증권저축 = d_value;
		            //} else if(data.code.equals("/Y7M")){    // 세액공제-외국납부			 20150126 제외
		            //        retData._세액공제_외국납부 = d_value;
		            } else if(data.code.equals("/Y7N")||(data.code.equals("/Y87")&&data.subCode.equals("20"))){    // 정치기부금
		                    retData._세액공제_정치기부금 += d_value;
		            //} else if(data.code.equals("/Y7Q")){    // 세액감면-소득세법정산			20150126 제외
		            //        retData._세액감면_소득세법정산 = d_value;
		            //} else if(data.code.equals("/Y7R")){    // 세액감면-조세특례제한법			20150126 제외
		            //        retData._세액감면_조세특례제한법 = d_value;
		            //} else if(data.code.equals("/Y7W")){    // 세액감면-장기주식펀드소득공제 2008.12		20150126 제외
		            //    retData._세액감면_장기주식형저축소득공제 = d_value;
		            } else if(data.code.equals("/Y7U")){    // 소기업.소상공인 공제부금 소득공제   "/Y7U" 20111.0		20150126 제외  [CSR ID:2974323] 연말정산 내역조회 오픈요청 20160203 추가
		                retData._소기업등소득공제 = d_value;
		            //} else if(data.code.equals("/Y7V")){    //  납세조합공제  C20120214_50550   20120214			20150126 제외
		            //    retData._납세조합공제 = d_value;

		            } else if(data.code.equals("/Y8I")){    // 결정세액(갑근세)_원단위 절사
		                   // retData._결정세액_갑근세 = d_value - (d_value % 10);
		            	 retData._결정세액_갑근세 = d_value ;

		            } else if(data.code.equals("/Y8R")){    // 결정세액(주민세)_원단위 절사
		                   // retData._결정세액_주민세 = d_value - (d_value % 10);
		                    retData._결정세액_주민세 = d_value;

		            } else if(data.code.equals("/Y8S")){    // 결정세액(농특세)_원단위 절사
		                    retData._결정세액_농특세 = d_value - (d_value % 10);
		            } else if(data.code.equals("/Y9I")){    // 기납부세액(갑근세)
		                    retData._기납부세액_갑근세 = d_value;
		            } else if(data.code.equals("/Y9R")){    // 기납부세액(주민세)
		                    retData._기납부세액_주민세 = d_value;
		            } else if(data.code.equals("/Y9S")){    // 기납부세액(농특세)
		                    retData._기납부세액_농특세 = d_value;

		            } else if(data.code.equals("/YAI")){    // 차감징수세액(갑근세)
		                    retData._차감징수세액_갑근세 = d_value;

		            } else if(data.code.equals("/YAR")){    // 차감징수세액(주민세)
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
		            } else if(data.code.equals("/YSP")){    // CSR ID:C20140106_63914 한부모가족
		                    retData._추가공제_한부모가족 = d_value;
		            } else if(data.code.equals("/YAA")){    // CSR ID:C20140106_63914 특별공제 종합한도 초과액
		                    retData._특별공제_종합한도_초과액 = d_value;

		                    //@2014 연말정산 조회 추가
		            } else if(data.code.equals("/YC4")){    // 세액공제
	                    retData._그밖의_장기집합투자증권저축 = d_value;
		            } else if(data.code.equals("/Y82")){    // 세액공제
		                    retData._세액공제_퇴직연금소득공제 = d_value;
		            } else if(data.code.equals("/Y83")){    // 세액공제
		                    retData._세액공제_연금저축소득공제 = d_value;
		            } else if(data.code.equals("/Y84")){    // _세액공제_보장성보험료
		                    retData._세액공제_보장성보험료 = d_value;
		            } else if(data.code.equals("/Y85")){    // 세액공제
		                    retData._세액공제_의료비 = d_value;
		            } else if(data.code.equals("/Y86")){    // 세액공제
		                    retData._세액공제_교육비 = d_value;
		            } else if(data.code.equals("/Y87")&&!data.subCode.equals("20")){    // 세액공제
		                    retData._세액공제_기부금 += d_value;
		            }
		     }else if("77".equals(data.reTax2014)){
		            if(data.code.equals("/Y3Z")){    // _세액공제_자녀_전 + reTax2014 = 77          [CSR ID:2778743]
	                    retData._세액공제_자녀_전 = d_value;
		            } else if(data.code.equals("/Y5Z")){    // 특별공제계(또는 표준공제) _세액공제_표준세액공제_전 + reTax2014 = 77          [CSR ID:2778743]
	                    retData._세액공제_표준세액공제_전 = d_value;
		            } else if(data.code.equals("/Y6M")){    // 신용카드공제_전 + reTax2014 = 77          [CSR ID:2778743]
                        retData._신용카드공제_전 = d_value;
		            } else if(data.code.equals("/Y7B")){    // 종합소득과세표준_전 + reTax2014 = 77          [CSR ID:2778743]
                        retData._종합소득과세표준_전 = d_value;
		            } else if(data.code.equals("/Y7C")){    // 산출세액_전 + reTax2014 = 77          [CSR ID:2778743]
                        retData._산출세액_전 = d_value;
		            } else if(data.code.equals("/Y7E")){    // 세액공제-근로소득_전 + reTax2014 = 77          [CSR ID:2778743]
	                    retData._세액공제_근로소득_전 = d_value;
		            } else if(data.code.equals("/Y8I")){    // 결정세액(갑근세)_원단위 절사     _결정세액_갑근세_전 + reTax2014 = 77          [CSR ID:2778743]
		                   // retData._결정세액_갑근세 = d_value - (d_value % 10);
		            	 retData._결정세액_갑근세_전 = d_value ;
		            } else if(data.code.equals("/Y8R")){    // 결정세액(주민세)_원단위 절사  _결정세액_주민세_전 + reTax2014 = 77          [CSR ID:2778743]
		                   // retData._결정세액_주민세 = d_value - (d_value % 10);
		                    retData._결정세액_주민세_전 = d_value;
		            } else if(data.code.equals("/Y8S")){    // 결정세액(농특세)_원단위 절사   _결정세액_농특세_전 + reTax2014 = 77          [CSR ID:2778743]
	                    retData._결정세액_농특세_전 = d_value - (d_value % 10);
		            } else if(data.code.equals("/YAI")){    // 차감징수세액(갑근세)   _전 + reTax2014 = 77          [CSR ID:2778743]
	                    retData._차감징수세액_갑근세_전 = d_value;
		            } else if(data.code.equals("/YAR")){    // 차감징수세액(주민세)   _전 + reTax2014 = 77          [CSR ID:2778743]
	                    retData._차감징수세액_주민세_전 = d_value;
		            } else if(data.code.equals("/YAS")){    // 차감징수세액(농특세)   _전 + reTax2014 = 77          [CSR ID:2778743]
	                    retData._차감징수세액_농특세_전 = d_value;
		            } else if(data.code.equals("/Y83")){    // _세액공제_연금저축소득공제_전 + reTax2014 = 77          [CSR ID:2778743]
	                    retData._세액공제_연금저축소득공제_전 = d_value;
		            } else if(data.code.equals("/Y84")){    // _세액공제_보장성보험료_전 + reTax2014 = 77          [CSR ID:2778743]
	                    retData._세액공제_보장성보험료_전 = d_value;
		            }
		     }//재정산에 따른 전 후 구분

		        }
        }


        // 현근무지 급여,상여정보를 다시 구한다.
        retData._급여총액 -= retData._전근무지_급여총액;
        retData._상여총액 -= retData._전근무지_상여총액;
        retData._인정상여 -= retData._전근무지_인정상여;


        if (gubn.equals("S")||gubn.equals("T")||gubn.equals("L")) { //2013    해외인경우만 S,T,L
	        //차감징수세액소득세 /Y8I - /Y9I
	        retData._차감징수세액_갑근세 = retData._결정세액_갑근세 - retData._기납부세액_갑근세;
	        //차감징수세액주민세 /Y8R - /Y9R
	        retData._차감징수세액_주민세 = retData._결정세액_주민세- retData._기납부세액_주민세;
	        //차감징수세액농특세 /Y8S - /Y9S
	        retData._차감징수세액_농특세 = retData._결정세액_농특세 - retData._기납부세액_농특세;

	        // [CSR ID:2778743] _전 추가
	        //차감징수세액소득세 /Y8I - /Y9I
	        retData._차감징수세액_갑근세_전 = retData._결정세액_갑근세_전 - retData._기납부세액_갑근세;
	        //차감징수세액주민세 /Y8R - /Y9R
	        retData._차감징수세액_주민세_전 = retData._결정세액_주민세_전- retData._기납부세액_주민세;
	        //차감징수세액농특세 /Y8S - /Y9S
	        retData._차감징수세액_농특세_전 = retData._결정세액_농특세_전 - retData._기납부세액_농특세;
        }

        //20150126 연말정산결과 조회
        //1) 경로 우대  => /Y3S+/Y3U
        retData._추가공제_경로우대 += retData._추가공제_경로우대70;

        //2) 주택자금(주택임차차입원리금상환액, 저당차입금이자상환액) => /Y5L+/Y54+/Y64


 /*20150126
  *       // 비과세소득 합계
        double hap7  = retData._비과세소득_국외근로    ;
               hap7 += retData._비과세소득_야간근로수당;
               hap7 += retData._비과세소득_기타비과세  ;
               hap7 += retData._전근무지_비과세해외소득;
               hap7 += retData._전근무지_비과세초과근무;
               hap7 += retData._전근무지_기타비과세대상;

        retData._비과세소득 = hap7;

        // 특별공제계(또는 표준공제) 도 계산 필요
        double hap  = retData._특별공제_보험료  ;
               hap += retData._특별공제_의료비  ;
               hap += retData._특별공제_교육비  ;
//             2008.12      hap += retData._특별공제_주택자금;
               hap += retData._특별공제_기부금  ;
			   //hap += retData._특별공제_경조사비  ;
			   hap += retData._특별공제_주택임차차입금원리금상환액; //2008.12
			   hap += retData._특별공제_주택자금이자상환액; //2008.12
			   hap += retData._특별공제_월세액; //2011.01
			   hap += retData._특별공제_주택저당차입금이자공제액; //2013.01


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
               hap2 += retData._추가공제_출산입양  ; //2008.12
               hap2 += retData._추가공제_한부모가족  ; //CSR ID:2013_9999

        //retData._차감소득금액 = retData._과세대상근로소득금액 - hap2 ; //2011.01

        // 특별공제_기부금 계산
//        retData._특별공제_기부금 = retData._특별공제_기부금1 + retData._특별공제_기부금2 ;

        // 세액공제합계 계산
        double hap3  = retData._세액공제_근로소득       ;
               hap3 += retData._세액공제_주택차입금     ;
               //hap3 += retData._세액공제_근로자주식저축 ;
               //hap3 += retData._장기증권저축            ;
			   hap3 += retData._정치기부금					;
			   hap3 += retData._납세조합공제					;
               hap3 += retData._세액공제_외국납부       ;

        retData._세액공제합계 = hap3 ;



        // 기납부세액합계 계산
//        retData._기납부세액_갑근세 += retData._전근무지_납부소득세;
//        retData._기납부세액_주민세 += retData._전근무지_납부주민세;
//        retData._기납부세액_농특세 += retData._전근무지_납부특별세;

     double hap5  = retData._기납부세액_갑근세 ;
               hap5 += retData._기납부세액_주민세 ;
               hap5 += retData._기납부세액_농특세 ;

        retData._기납부세액합계 = hap5 ;
*/

        // 결정세액합계 계산
        double hap4  = retData._결정세액_갑근세 ;
               hap4 += retData._결정세액_주민세 ;
               hap4 += retData._결정세액_농특세 ;

        retData._결정세액합계 = hap4 ;

        // [CSR ID:2778743]
        // 결정세액합계_전 계산
        double hap7  = retData._결정세액_갑근세_전 ;
               hap7 += retData._결정세액_주민세_전 ;
               hap7 += retData._결정세액_농특세_전 ;

        retData._결정세액합계_전 = hap7 ;


        // 차감징수세액합계 계산
        double hap6  = retData._차감징수세액_갑근세 ;
               hap6 += retData._차감징수세액_주민세 ;
               hap6 += retData._차감징수세액_농특세 ;

        retData._차감징수세액합계 = hap6 ;

        // [CSR ID:2778743]
        // 차감징수세액합계_전 계산
        double hap8  = retData._차감징수세액_갑근세_전 ;
               hap8 += retData._차감징수세액_주민세_전 ;
               hap8 += retData._차감징수세액_농특세_전 ;

        retData._차감징수세액합계_전 = hap8 ;

        //[CSR ID:2778743]
        retData._차감징수세액합계_2014 = retData._차감징수세액합계 - retData._차감징수세액합계_전 ;

//        retData._연금보험료공제_국민 = retData._연금보험료공제 + Data_P16 - Data_Y6N; //   "/Y6A+ /P16 - /Y6N" 20111.01


       //  Logger.debug.println(this, retData.toString());
 //Logger.debug.println(this, retData.toString());
        return retData ;
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput1(JCO.Function function) throws GeneralException {

    	// Export 변수 조회
    	String fieldName1 = "E_RETTEXT";     // 다이얼로그 인터페이스에 대한 메세지텍스트
    	String E_MESSAGE  = getField(fieldName1, function) ;

    	//Logger.debug.println(this, "function:"+function +"E_MESSAGE"+E_MESSAGE);
    	return E_MESSAGE;
    }

}