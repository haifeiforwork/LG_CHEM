package hris.D ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 * D13TaxAdjustSimulation.java
 * 연말정산 시뮬레이션
 * 
 * @author 김성일 
 * @version 1.0, 2001/12/24
 */
public class D13TaxAdjustSimulation {

    private D13TaxAdjustData data = new D13TaxAdjustData();
    private D14TaxAdjustData retData = new D14TaxAdjustData();
    private final double MANWON = 10000 ; // 원화 백만원을 칭한다

    private double _산출세액원금 = 0;     // 투자조합출자 소득공제가 없을경우의 산출세액

/*---------- Function -------------------------------------------------------*/

    public Object simulate(D13TaxAdjustData inputData) throws GeneralException {

        try{
            this.data = inputData;

            // 농특세 계산을 위한 부분
            if( (cal투자조합공제I(data._투자조합공제I) + cal투자조합공제II(data._투자조합공제II)) > 0 ){
                set근로소득금액(data._과세대상근로소득);
                set과세표준();
                data._과세표준 = data._과세표준 - (cal투자조합공제I(data._투자조합공제I) + cal투자조합공제II(data._투자조합공제II));
                set기본세율();
                double _산출세액원금 = get산출세액();

                retData = new D14TaxAdjustData();
                this.data = inputData;
            }
Logger.debug.println(this,"after      data._산출세액 : "+data._산출세액);

            set근로소득금액(data._과세대상근로소득);
Logger.debug.println(this,"after  set근로소득금액(data._과세대상근로소득);    data._산출세액 : "+data._산출세액);
            set과세표준();
Logger.debug.println(this,"after  set과세표준();    data._산출세액 : "+data._산출세액);
            set기본세율();
Logger.debug.println(this,"after  set기본세율();    data._산출세액 : "+data._산출세액);
            set산출세액();
Logger.debug.println(this,"after  set산출세액();    data._산출세액 : "+data._산출세액);

            set근로세액공제(data._산출세액);
Logger.debug.println(this,"after  set근로세액공제(data._산출세액);    data._산출세액 : "+data._산출세액);
            set결정세액();
            set납부환급액();

            setData();

Logger.debug.println(this,retData.toString());
            return retData;
        } catch(Exception ex){
            Logger.sap.println(this, ex.toString());
            throw new GeneralException(ex);
        }
    }

    private void setData() throws GeneralException {
/*
        //retData._근로소득공제          
        retData._기본공제_본인         
        retData._기본공제_배우자       
        retData._기본공제_부양가족     
        retData._추가공제_경로우대     
        retData._추가공제_장애인       
        retData._추가공제_부녀자       
        retData._추가공제_자녀양육비   
        retData._소수공제자추가공제    
*/
        /*
        double total = 0.0;
        total += cal의료보험료(data._의료보험료) ; // 의료보험
        total += cal고용보험료(data._고용보험료) ; // 고용보험
        total += sum보험료(data._보험료일반,data._보험료장애자) ; // 보험료
        retData._특별공제_보험료 = total ;

        retData._특별공제_기부금 = sum기부금(data._기부금법정,data._기부금지정) ; 
        retData._특별공제_의료비 = sum의료비(data._의료비일반+data._의료비경로장애,data._의료비경로장애);     
        retData._특별공제_교육비 = sum교육비();     
        retData._특별공제_주택자금 = sum주택자금(data._주택자금저축금액,data._주택자금차입원리금,data._주택자금차입이자상환);

        retData._특별공제계 = get특별공제계();
        retData._연금보험료공제 = cal국민연금(data._국민연금);       
        retData._개인연금저축소득공제  = cal개인연금I(data._개인연금I) ;  
        retData._연금저축소득공제 = cal개인연금II( data._개인연금II) ;
        retData._투자조합출자등소득공제 = cal투자조합공제I(data._투자조합공제I) + cal투자조합공제II(data._투자조합공제II);
        retData._신용카드공제 = cal신용카드공제(data._신용카드공제) ;

        retData._세액공제_주택차입금 = cal주택자금이자상환(data._주택자금이자상환) ;
        retData._세액공제_근로자주식저축 = cal근로자주식저축(data._근로자주식저축) ;
        retData._세액공제_외국납부 = cal외국납부세당년(data._외국납부세당년,data._외국납부세이월분); 
        retData._장기증권저축 = cal장기증권저축(data._장기증권저축) ;
                                    
        // 결정세액 계산
        retData._결정세액_갑근세 = DataUtil.nelim( data._결정세액 , -1 );
        retData._결정세액_주민세 = DataUtil.nelim( data._결정세액 * 0.1 , -1 );
        retData._결정세액_농특세 = DataUtil.nelim( cal주택자금이자상환(data._주택자금이자상환) * 0.2 , -1 );
        if( retData._투자조합출자등소득공제 > 0 ){
            retData._결정세액_농특세 += data._산출세액 - _산출세액원금;// 투자조합출자 등 소득공제를 받은 근로자의 산출세액의 차액
        }

        //retData._결정세액_갑근세       
        //retData._결정세액_주민세       
        //retData._결정세액_농특세       
        //retData._차감소득금액
                                   
        retData._종합소득과세표준 = data._과세표준 ;
        retData._산출세액 = data._산출세액 ;
        retData._세액공제_근로소득 = data._근로세액공제;
        retData._세액공제합계 = get세액공제계();

       // retData._결정세액합계 
        //retData._기납부세액합계        
                                    
        //retData._차감징수세액_갑근세 = 
        //retData._차감징수세액_주민세   
        //retData._차감징수세액_농특세   
        //retData._차감징수세액합계      */

    }

/*---------------------------------------------------------------------------*/
/*- 초기값 설정  ------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

// 근로소득금액 계산 .. (근로소득공제 계산후)
    public void set근로소득금액(double _과세대상근로소득) throws GeneralException {
        try{
            double result = 0.0;                    // 근로소득공제액

            // 총급여액이 500만원 이하일경우
            if( _과세대상근로소득 <= ( 500*MANWON ) ){
                result = _과세대상근로소득 * 1 ;

            // 총급여액이 500만원 초과 1,500만원 이하일경우
            } else if( (_과세대상근로소득 > ( 500*MANWON )) && (_과세대상근로소득 <= ( 1500*MANWON )) ){
                result = (_과세대상근로소득 * 0.4) + (300 * MANWON) ;

            // 총급여액이 1,500만원 초과 4,500만원 이하일경우
            } else if( (_과세대상근로소득 > ( 1500*MANWON )) && (_과세대상근로소득 <= ( 4500*MANWON )) ){
                result = (_과세대상근로소득 * 0.1) + (750 * MANWON) ;
            
            // 총급여액이 4,500만원 이상일경우
            } else if( _과세대상근로소득 > ( 4500*MANWON ) ){
                result = (_과세대상근로소득 * 0.05) + (975 * MANWON) ;
            }

            retData._근로소득공제 = result;
            // 근로소득금액 = 과세대상근로소득 - 근로소득공제 ;
            data._근로소득금액 = _과세대상근로소득 - result ;

            // 과세대상근로소득금액.. 계산 수정.. 김성일 2002-02-25
            retData._과세대상근로소득금액 = data._근로소득금액;
            // 과세대상근로소득금액.. 계산 수정.. 김성일 2002-02-25
        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }

// 기본세율 계산 .. 
    public void set기본세율() throws GeneralException {
        try{
            double result = 0.0;                    // 기본세율
            double _과세표준 = data._과세표준;

            // 과세표준액이 1,000만원 이하일경우
            if( _과세표준 > 0 && _과세표준 <= ( 1000*MANWON ) ){
                result = 0.1 ;

            // 과세표준액이 1,000만원 초과 4,000만원 이하일경우
            } else if( (_과세표준 > ( 1000*MANWON )) && (_과세표준 <= ( 4000*MANWON )) ){
                result = 0.2 ;

            // 과세표준액이 4,000만원 초과 8,000만원 이하일경우
            } else if( (_과세표준 > ( 4000*MANWON )) && (_과세표준 <= ( 8000*MANWON )) ){
                result = 0.3 ;
            
            // 과세표준액이 8,000만원 이상일경우
            } else if( _과세표준 > ( 8000*MANWON ) ){
                result = 0.4 ;
            }

            data._기본세율 = result ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 과세표준 계산 .. 
    public void set과세표준() throws GeneralException {
        try{
            double total  = data._근로소득금액   ; // 근로소득금액
                   total -= get인적공제계() ; // 인적공제계
                   total -= get특별공제계() ; // 특별공제계
                   total -= get기타공제계() ; // 기타공제계
            //return total ;
            data._과세표준 = total;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 산출세액 계산 .. 
    public void set산출세액() throws GeneralException {
        try{
            double progress = 0.0;
            if(data._기본세율 > 0.1) progress +=  100 * MANWON ;
            if(data._기본세율 > 0.2) progress +=  500 * MANWON ;
            if(data._기본세율 > 0.3) progress += 1300 * MANWON ;

            data._산출세액 = (data._과세표준 * data._기본세율) - progress ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 산출세액 계산 .. 농특세 계산에서만 호출된다. 투자조합출자소득공제가 없으면 호출되지 않는다.
    public double get산출세액() throws GeneralException {
        try{
            double progress = 0.0;
            if(data._기본세율 > 0.1) progress +=  100 * MANWON ;
            if(data._기본세율 > 0.2) progress +=  500 * MANWON ;
            if(data._기본세율 > 0.3) progress += 1300 * MANWON ;

            return ((data._과세표준 * data._기본세율) - progress) ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 근로세액공제 계산 .. 
    public void set근로세액공제(double _산출세액) throws GeneralException {
        try{
            double result = 0.0;                    // 근로세액공제
            double limit  = 60 * MANWON ;           // 한도액 60 만원

            // 산출세액이 50만원이하일 경우
            if( _산출세액  <= ( 50*MANWON ) ){
                result = _산출세액 * 0.45 ;

            // 산출세액이 50만원초과일 경우
            } else if( _산출세액 > ( 50*MANWON ) ){
                result = (22.5*MANWON) + ((_산출세액-( 50*MANWON )) * 0.3 ) ;
            }

            //return result ;
            data._근로세액공제 = ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 결정세액 계산 .. 
    public void set결정세액() throws GeneralException {
        try{
            data._결정세액 = data._산출세액 - get세액공제계() ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// _납부환급액 계산 .. 
    public void set납부환급액() throws GeneralException {
        try{
            data._납부환급액 = data._결정세액 - data._기납부세액 ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*---------------------------------------------------------------------------*/
/*- 각 항목별로 소계를 계산 -------------------------------------------------*/
/*---------------------------------------------------------------------------*/

/*--- 인적공제 계 -----------------------------------------------------------*/
    public double get인적공제계() throws GeneralException {
        try{
Logger.debug.println(this, "인적공제 계 : "+data._인적공제총액);
            return data._인적공제총액 ;
        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*--- 특별공제 계 -----------------------------------------------------------*/
    public double get특별공제계() throws GeneralException {
        try{
            double minimum = 60 * MANWON ;      // 표준공제 60만원
            double total = 0.0;
            total += cal의료보험료(data._의료보험료)                                              ; // 의료보험
            total += cal고용보험료(data._고용보험료)                                              ; // 고용보험
            total += sum보험료(data._보험료일반,data._보험료장애자)                                    ; // 보험료
            total += sum의료비(data._의료비일반+data._의료비경로장애,data._의료비경로장애)                                  ; // 의료비
            total += sum주택자금(data._주택자금저축금액,data._주택자금차입원리금,data._주택자금차입이자상환); // 주택자금
            total += sum기부금(data._기부금법정,data._기부금지정)                                      ; // 기부금
            total += sum교육비()                                                             ; // 교육비
Logger.debug.println(this, "특별공제 계 : "+total);
            return ( (total < minimum) ? minimum : total ) ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*--- 기타공제 계 -----------------------------------------------------------*/
    public double get기타공제계() throws GeneralException {
        try{
            double total = 0.0;
            total  = cal개인연금I(data._개인연금I)          ; // 개인연금I
            total += cal개인연금II( data._개인연금II)        ; // 개인연금II
            total += cal국민연금(data._국민연금)            ; // 국민연금
            total += cal투자조합공제I(data._투자조합공제I)  ; // 투자조합공제I
            total += cal투자조합공제II(data._투자조합공제II); // 투자조합공제II
            total += cal신용카드공제(data._신용카드공제)    ; // 신용카드소득공제
Logger.debug.println(this, "기타공제 계 : "+total);
            return total ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*--- 세액공제 계 -----------------------------------------------------------*/
    public double get세액공제계() throws GeneralException {
        try{
            double total = 0.0;
            total  = data._근로세액공제                          ; // 근로소득세액공제
            total += cal주택자금이자상환(data._주택자금이자상환) ; // cal주택자금이자상환
            total += cal근로자주식저축(data._근로자주식저축)     ; // cal근로자주식저축
            total += cal장기증권저축(data._장기증권저축)         ; // cal장기증권저축
            total += cal외국납부세당년(data._외국납부세당년,data._외국납부세이월분); // cal외국납부세당년
Logger.debug.println(this, "세액공제 계 : "+total);
            return total ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*---------------------------------------------------------------------------*/

// 교육비공제 소계   ???
    public double sum교육비() throws GeneralException {
        try{
            double total = 0.0;
            total  = cal교육비본인(data._교육비본인)    ; // 교육비본인   
            total += cal교육비영유아(data._교육비영유아); // 교육비영유아
            total += cal교육비초중고(data._교육비초중고); // 교육비초중고
            total += cal교육비대학(data._교육비대학)    ; // 교육비대학
Logger.debug.println(this, "교육비공제 소계 : "+total);
            return total;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 보험료공제 소계
    public double sum보험료(double _보험료일반, double _보험료장애자) throws GeneralException {
        try{
Logger.debug.println(this, "보험료공제 소계 : "+( cal보험료일반(_보험료일반) + cal보험료장애자(_보험료장애자) ));
            return ( cal보험료일반(_보험료일반) + cal보험료장애자(_보험료장애자) );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 의료비공제 소계
    public double sum의료비(double _의료비일반, double _의료비경로장애) throws GeneralException {
        try{
Logger.debug.println(this, "의료비공제 소계 : "+( cal의료비일반(_의료비일반)+"+"+cal의료비경로장애(_의료비일반, _의료비경로장애) )+"="+( cal의료비일반(_의료비일반) + cal의료비경로장애(_의료비일반, _의료비경로장애) ));
            return ( cal의료비일반(_의료비일반) + cal의료비경로장애(_의료비일반, _의료비경로장애) );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 주택자금공제 소계
    public double sum주택자금(double _주택자금저축금액, double _주택자금차입원리금, double _주택자금차입이자상환) throws GeneralException {
        try{
            double limit   = 300 * MANWON ;  // 한도액 300만원

            double sum주택자금 = cal주택자금저축금액( _주택자금저축금액) + cal주택자금차입원리금( _주택자금차입원리금) + cal주택자금차입이자상환( _주택자금차입이자상환) ;
Logger.debug.println(this, "주택자금공제 소계 : "+( (sum주택자금 > limit) ? limit : sum주택자금 ));
            return ( (sum주택자금 > limit) ? limit : sum주택자금 );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 기부금특별공제
    public double sum기부금(double _기부금법정, double _기부금지정) throws GeneralException {
        try{
Logger.debug.println(this, "기부금특별공제 : "+( cal기부금법정(_기부금법정) + cal기부금지정(_기부금법정, _기부금지정) ));
            return ( cal기부금법정(_기부금법정) + cal기부금지정(_기부금법정, _기부금지정) );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }

/*---------------------------------------------------------------------------*/
/*- 각 세부항목별로 실제공제금액 계산해서 return 하는 method 들 -------------*/
/*---------------------------------------------------------------------------*/

// 의료보험
    public double cal의료보험료(double _의료보험료) throws GeneralException {
        try{

Logger.debug.println(this, "의료보험 : "+_의료보험료);
            return _의료보험료 ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 고용보험
    public double cal고용보험료(double _고용보험료) throws GeneralException {
        try{

Logger.debug.println(this, "고용보험 : "+_고용보험료);
            return _고용보험료 ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 보험료(일반).. 보장성 보험료
    public double cal보험료일반(double _보험료일반) throws GeneralException {
        try{
            double limit   = 70 * MANWON ;  // 한도액 70만원

            double result = _보험료일반 ;
Logger.debug.println(this, "보험료(일반).. 보장성 보험료 : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 보험료(장애자)
    public double cal보험료장애자(double _보험료장애자) throws GeneralException {
        try{
            double limit   = 100 * MANWON ;  // 한도액 100만원

            double result = _보험료장애자 ;
Logger.debug.println(this, "보험료(장애자) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 의료비(일반) ... 의료비지급액 - (근로소득수입금액 * 3 %) 
    public double cal의료비일반(double _의료비일반) throws GeneralException {
        try{
            double limit   = 300 * MANWON ;  // 한도액 300만원
            double percent = 0.03         ;  // 3 %

            double result = _의료비일반 - (data._과세대상근로소득 * percent) ;
            if(result < 0) result = 0 ;
Logger.debug.println(this, "의료비(일반) ... 의료비지급액 - (근로소득수입금액 * 3 %) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 의료비(경로+장애)
// 경로우대자 및 장애자 재활의료비 공제 가 있을시에는 공제액중 200만원 초과액과 
// 의료비경로 재활의료비 중 적은 금액을 추가공제
    public double cal의료비경로장애(double _의료비일반, double _의료비경로장애) throws GeneralException {
        try{
            double old_result = cal의료비일반(_의료비일반) ;
            
            double extra = old_result - (200 * MANWON) ;
            double result = ( (extra > _의료비경로장애) ? _의료비경로장애 : extra );
            if(result < 0) result = 0 ;
Logger.debug.println(this, "의료비(경로+장애) : "+result);
            return result;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 주택자금(저축금액)
    public double cal주택자금저축금액(double _주택자금저축금액) throws GeneralException {
        try{
            double percent = 0.4         ;  // 40 %

            double result = _주택자금저축금액 * percent ;
Logger.debug.println(this, "주택자금(저축금액) : "+result);
            return result ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 주택자금(차입원리금)
    public double cal주택자금차입원리금(double _주택자금차입원리금) throws GeneralException {
        try{
            double percent = 0.4         ;  // 40 %

            double result = _주택자금차입원리금 * percent ;
Logger.debug.println(this, "주택자금(차입원리금) : "+result);
            return result ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 주택자금(차입이자상환).. 원금제외
    public double cal주택자금차입이자상환(double _주택자금차입이자상환) throws GeneralException {
        try{
            double percent = 1.0         ;  // 100 %

            double result = _주택자금차입이자상환 * percent ;
Logger.debug.println(this, "주택자금(차입이자상환) : "+result);
            return result ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 기부금(법정)
    public double cal기부금법정(double _기부금법정) throws GeneralException {
        try{

Logger.debug.println(this, "기부금(법정) : "+_기부금법정);
            return _기부금법정;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 기부금(지정)
    public double cal기부금지정(double _기부금법정, double _기부금지정) throws GeneralException {
        try{
            double percent = 0.1         ;  // 10 %
            double limit   = (data._근로소득금액 - cal기부금법정(_기부금법정) ) * percent ;  // 한도액 

            double result = _기부금지정 ;
Logger.debug.println(this, "기부금(지정) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 교육비 본인
    public double cal교육비본인(double _교육비본인) throws GeneralException {
        try{
            
Logger.debug.println(this, "교육비 본인 : "+_교육비본인);
            return _교육비본인;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 교육비 부양가족(영유아)
    public double cal교육비영유아(double _교육비영유아) throws GeneralException {
        try{
            double limit   = 100 * MANWON ;  // 한도액 100만원
            double result = _교육비영유아 ;
Logger.debug.println(this, "교육비 부양가족(영유아) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 교육비 부양가족(초중고)
    public double cal교육비초중고(double _교육비초중고) throws GeneralException {
        try{
            double limit   = 150* MANWON ;  // 한도액 150만원
            double result = _교육비초중고 ;
Logger.debug.println(this, "교육비 부양가족(초중고) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 교육비 부양가족(대학)
    public double cal교육비대학(double _교육비대학) throws GeneralException {
        try{
            double limit   = 300 * MANWON ;  // 한도액 300만원
            double result = _교육비대학 ;
Logger.debug.println(this, "교육비 부양가족(대학) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 개인연금 I... ? 개인연금공제 당해연도 불입액의 40%공제(한도 72만원)
    public double cal개인연금I(double _개인연금I) throws GeneralException {
        try{
            double percent = 0.4         ;  // 당해연도 불입액의 40%공제
            double limit   = 72 * MANWON ;  // 한도액 72만원

            double result = _개인연금I * percent ;
Logger.debug.println(this, "개인연금 I : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 개인연금 II... ? 연금저축공제 한도 240만원
    public double cal개인연금II(double _개인연금II) throws GeneralException {
        try{
            double limit   = 240 * MANWON  ;  // 한도액 240만원

            double result = _개인연금II ;
Logger.debug.println(this, "개인연금 II : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 국민연금
    public double cal국민연금(double _국민연금) throws GeneralException {
        try{
            double percent = 0.5         ;  // 국민연금 본인부담액의 50%

            double result = _국민연금 * percent ;
Logger.debug.println(this, "국민연금 : "+result);
            return result;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 투자조합공제 I .. 1999.08.31 이전 출자분 에대해선 20% 적용
    public double cal투자조합공제I(double _투자조합공제I) throws GeneralException {
        try{
            double percent = 0.2         ;  // 20% 적용
            double limit   = data._근로소득금액 * 0.7 ;  // 당해 과세연도 근로(종합)소득금액의 70%

            double result = _투자조합공제I * percent ;
Logger.debug.println(this, "투자조합공제 I  : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 투자조합공제 II 
    public double cal투자조합공제II(double _투자조합공제II) throws GeneralException {
        try{
            double percent = 0.3         ;  // 출자액의 30% 적용
            double limit   = data._근로소득금액 * 0.7 ;  // 당해 과세연도 근로(종합)소득금액의 70%

            double result = _투자조합공제II * percent ;
Logger.debug.println(this, "투자조합공제 II : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 신용카드공제
    public double cal신용카드공제(double _신용카드공제) throws GeneralException {
        try{
            double cardWon = _신용카드공제 - (data._총급여 * 0.1) ;  // 신용카드사용금액 - 총급여의 10%
            if( cardWon <= 0 ){
Logger.debug.println(this, "신용카드공제 : 0.0");
                return 0.0;
            } else {
                double percent = 0.2          ;  // 20% 적용
                double limit   = 500 * MANWON ;  // 한도액 500만원과 총급여의 20% 중 적은금액
                limit = ( (limit > (data._총급여 * 0.2) ) ? (data._총급여 * 0.2) : limit );

                double result = cardWon * percent ;
Logger.debug.println(this, "신용카드공제 : "+( (result > limit) ? limit : result ));
                return ( (result > limit) ? limit : result );
            }
        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 주택자금이자상환
    public double cal주택자금이자상환(double _주택자금이자상환) throws GeneralException {
        try{
            double percent = 0.3         ;  // 이자상환액의 30%
            double limit = data._산출세액 ;
            double result = _주택자금이자상환 * percent ;
Logger.debug.println(this, "주택자금이자상환 : "+result);
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 근로자주식저축
    public double cal근로자주식저축(double _근로자주식저축) throws GeneralException {
        try{
            double percent = 0.05         ;  // 5%
            double limit = data._산출세액 ;
            double result = _근로자주식저축 * percent ;
Logger.debug.println(this, "근로자주식저축 : "+result);
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 장기증권저축
    public double cal장기증권저축(double _장기증권저축) throws GeneralException {
        try{
            double percent = 0.05         ;  // 5 %
            double limit = data._산출세액 ;
            double result = _장기증권저축 * percent ;
Logger.debug.println(this, "장기증권저축 : "+result);
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// 외국납부세(당년), 외국납부세(이월분)
    public double cal외국납부세당년(double _외국납부세당년, double _외국납부세이월분) throws GeneralException {
        try{
            double limit = 0.0 ;
            if(data._근로소득금액 != 0){
                limit = data._산출세액 * ( data._국외원천근로소득금액 / data._근로소득금액 ) ; // 
            }
            double result = (_외국납부세당년 + _외국납부세이월분) ;
Logger.debug.println(this,"data._국외원천근로소득금액 : "+ data._국외원천근로소득금액);
Logger.debug.println(this,"data._근로소득금액 : "+ data._근로소득금액);
Logger.debug.println(this,"data._산출세액 : "+data._산출세액);
Logger.debug.println(this,"limit : "+ limit);
Logger.debug.println(this,"result : "+ result);
Logger.debug.println(this,(result > limit)+"" );
Logger.debug.println(this, "외국납부세(당년), 외국납부세(이월분) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*---------------------------------------------------------------------------*/
}
