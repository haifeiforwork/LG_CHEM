package hris.D ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;

import hris.D.* ;

/**
 * D13TaxAdjustSimulation.java
 * �������� �ùķ��̼�
 * 
 * @author �輺�� 
 * @version 1.0, 2001/12/24
 */
public class D13TaxAdjustSimulation {

    private D13TaxAdjustData data = new D13TaxAdjustData();
    private D14TaxAdjustData retData = new D14TaxAdjustData();
    private final double MANWON = 10000 ; // ��ȭ �鸸���� Ī�Ѵ�

    private double _���⼼�׿��� = 0;     // ������������ �ҵ������ ��������� ���⼼��

/*---------- Function -------------------------------------------------------*/

    public Object simulate(D13TaxAdjustData inputData) throws GeneralException {

        try{
            this.data = inputData;

            // ��Ư�� ����� ���� �κ�
            if( (cal�������հ���I(data._�������հ���I) + cal�������հ���II(data._�������հ���II)) > 0 ){
                set�ٷμҵ�ݾ�(data._�������ٷμҵ�);
                set����ǥ��();
                data._����ǥ�� = data._����ǥ�� - (cal�������հ���I(data._�������հ���I) + cal�������հ���II(data._�������հ���II));
                set�⺻����();
                double _���⼼�׿��� = get���⼼��();

                retData = new D14TaxAdjustData();
                this.data = inputData;
            }
Logger.debug.println(this,"after      data._���⼼�� : "+data._���⼼��);

            set�ٷμҵ�ݾ�(data._�������ٷμҵ�);
Logger.debug.println(this,"after  set�ٷμҵ�ݾ�(data._�������ٷμҵ�);    data._���⼼�� : "+data._���⼼��);
            set����ǥ��();
Logger.debug.println(this,"after  set����ǥ��();    data._���⼼�� : "+data._���⼼��);
            set�⺻����();
Logger.debug.println(this,"after  set�⺻����();    data._���⼼�� : "+data._���⼼��);
            set���⼼��();
Logger.debug.println(this,"after  set���⼼��();    data._���⼼�� : "+data._���⼼��);

            set�ٷμ��װ���(data._���⼼��);
Logger.debug.println(this,"after  set�ٷμ��װ���(data._���⼼��);    data._���⼼�� : "+data._���⼼��);
            set��������();
            set����ȯ�޾�();

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
        //retData._�ٷμҵ����          
        retData._�⺻����_����         
        retData._�⺻����_�����       
        retData._�⺻����_�ξ簡��     
        retData._�߰�����_��ο��     
        retData._�߰�����_�����       
        retData._�߰�����_�γ���       
        retData._�߰�����_�ڳ������   
        retData._�Ҽ��������߰�����    
*/
        /*
        double total = 0.0;
        total += cal�ǷẸ���(data._�ǷẸ���) ; // �ǷẸ��
        total += cal��뺸���(data._��뺸���) ; // ��뺸��
        total += sum�����(data._������Ϲ�,data._����������) ; // �����
        retData._Ư������_����� = total ;

        retData._Ư������_��α� = sum��α�(data._��αݹ���,data._��α�����) ; 
        retData._Ư������_�Ƿ�� = sum�Ƿ��(data._�Ƿ���Ϲ�+data._�Ƿ�������,data._�Ƿ�������);     
        retData._Ư������_������ = sum������();     
        retData._Ư������_�����ڱ� = sum�����ڱ�(data._�����ڱ�����ݾ�,data._�����ڱ����Կ�����,data._�����ڱ��������ڻ�ȯ);

        retData._Ư�������� = getƯ��������();
        retData._���ݺ������� = cal���ο���(data._���ο���);       
        retData._���ο�������ҵ����  = cal���ο���I(data._���ο���I) ;  
        retData._��������ҵ���� = cal���ο���II( data._���ο���II) ;
        retData._�����������ڵ�ҵ���� = cal�������հ���I(data._�������հ���I) + cal�������հ���II(data._�������հ���II);
        retData._�ſ�ī����� = cal�ſ�ī�����(data._�ſ�ī�����) ;

        retData._���װ���_�������Ա� = cal�����ڱ����ڻ�ȯ(data._�����ڱ����ڻ�ȯ) ;
        retData._���װ���_�ٷ����ֽ����� = cal�ٷ����ֽ�����(data._�ٷ����ֽ�����) ;
        retData._���װ���_�ܱ����� = cal�ܱ����μ����(data._�ܱ����μ����,data._�ܱ����μ��̿���); 
        retData._����������� = cal�����������(data._�����������) ;
                                    
        // �������� ���
        retData._��������_���ټ� = DataUtil.nelim( data._�������� , -1 );
        retData._��������_�ֹμ� = DataUtil.nelim( data._�������� * 0.1 , -1 );
        retData._��������_��Ư�� = DataUtil.nelim( cal�����ڱ����ڻ�ȯ(data._�����ڱ����ڻ�ȯ) * 0.2 , -1 );
        if( retData._�����������ڵ�ҵ���� > 0 ){
            retData._��������_��Ư�� += data._���⼼�� - _���⼼�׿���;// ������������ �� �ҵ������ ���� �ٷ����� ���⼼���� ����
        }

        //retData._��������_���ټ�       
        //retData._��������_�ֹμ�       
        //retData._��������_��Ư��       
        //retData._�����ҵ�ݾ�
                                   
        retData._���ռҵ����ǥ�� = data._����ǥ�� ;
        retData._���⼼�� = data._���⼼�� ;
        retData._���װ���_�ٷμҵ� = data._�ٷμ��װ���;
        retData._���װ����հ� = get���װ�����();

       // retData._���������հ� 
        //retData._�ⳳ�μ����հ�        
                                    
        //retData._����¡������_���ټ� = 
        //retData._����¡������_�ֹμ�   
        //retData._����¡������_��Ư��   
        //retData._����¡�������հ�      */

    }

/*---------------------------------------------------------------------------*/
/*- �ʱⰪ ����  ------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

// �ٷμҵ�ݾ� ��� .. (�ٷμҵ���� �����)
    public void set�ٷμҵ�ݾ�(double _�������ٷμҵ�) throws GeneralException {
        try{
            double result = 0.0;                    // �ٷμҵ������

            // �ѱ޿����� 500���� �����ϰ��
            if( _�������ٷμҵ� <= ( 500*MANWON ) ){
                result = _�������ٷμҵ� * 1 ;

            // �ѱ޿����� 500���� �ʰ� 1,500���� �����ϰ��
            } else if( (_�������ٷμҵ� > ( 500*MANWON )) && (_�������ٷμҵ� <= ( 1500*MANWON )) ){
                result = (_�������ٷμҵ� * 0.4) + (300 * MANWON) ;

            // �ѱ޿����� 1,500���� �ʰ� 4,500���� �����ϰ��
            } else if( (_�������ٷμҵ� > ( 1500*MANWON )) && (_�������ٷμҵ� <= ( 4500*MANWON )) ){
                result = (_�������ٷμҵ� * 0.1) + (750 * MANWON) ;
            
            // �ѱ޿����� 4,500���� �̻��ϰ��
            } else if( _�������ٷμҵ� > ( 4500*MANWON ) ){
                result = (_�������ٷμҵ� * 0.05) + (975 * MANWON) ;
            }

            retData._�ٷμҵ���� = result;
            // �ٷμҵ�ݾ� = �������ٷμҵ� - �ٷμҵ���� ;
            data._�ٷμҵ�ݾ� = _�������ٷμҵ� - result ;

            // �������ٷμҵ�ݾ�.. ��� ����.. �輺�� 2002-02-25
            retData._�������ٷμҵ�ݾ� = data._�ٷμҵ�ݾ�;
            // �������ٷμҵ�ݾ�.. ��� ����.. �輺�� 2002-02-25
        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }

// �⺻���� ��� .. 
    public void set�⺻����() throws GeneralException {
        try{
            double result = 0.0;                    // �⺻����
            double _����ǥ�� = data._����ǥ��;

            // ����ǥ�ؾ��� 1,000���� �����ϰ��
            if( _����ǥ�� > 0 && _����ǥ�� <= ( 1000*MANWON ) ){
                result = 0.1 ;

            // ����ǥ�ؾ��� 1,000���� �ʰ� 4,000���� �����ϰ��
            } else if( (_����ǥ�� > ( 1000*MANWON )) && (_����ǥ�� <= ( 4000*MANWON )) ){
                result = 0.2 ;

            // ����ǥ�ؾ��� 4,000���� �ʰ� 8,000���� �����ϰ��
            } else if( (_����ǥ�� > ( 4000*MANWON )) && (_����ǥ�� <= ( 8000*MANWON )) ){
                result = 0.3 ;
            
            // ����ǥ�ؾ��� 8,000���� �̻��ϰ��
            } else if( _����ǥ�� > ( 8000*MANWON ) ){
                result = 0.4 ;
            }

            data._�⺻���� = result ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ����ǥ�� ��� .. 
    public void set����ǥ��() throws GeneralException {
        try{
            double total  = data._�ٷμҵ�ݾ�   ; // �ٷμҵ�ݾ�
                   total -= get����������() ; // ����������
                   total -= getƯ��������() ; // Ư��������
                   total -= get��Ÿ������() ; // ��Ÿ������
            //return total ;
            data._����ǥ�� = total;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ���⼼�� ��� .. 
    public void set���⼼��() throws GeneralException {
        try{
            double progress = 0.0;
            if(data._�⺻���� > 0.1) progress +=  100 * MANWON ;
            if(data._�⺻���� > 0.2) progress +=  500 * MANWON ;
            if(data._�⺻���� > 0.3) progress += 1300 * MANWON ;

            data._���⼼�� = (data._����ǥ�� * data._�⺻����) - progress ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ���⼼�� ��� .. ��Ư�� ��꿡���� ȣ��ȴ�. �����������ڼҵ������ ������ ȣ����� �ʴ´�.
    public double get���⼼��() throws GeneralException {
        try{
            double progress = 0.0;
            if(data._�⺻���� > 0.1) progress +=  100 * MANWON ;
            if(data._�⺻���� > 0.2) progress +=  500 * MANWON ;
            if(data._�⺻���� > 0.3) progress += 1300 * MANWON ;

            return ((data._����ǥ�� * data._�⺻����) - progress) ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �ٷμ��װ��� ��� .. 
    public void set�ٷμ��װ���(double _���⼼��) throws GeneralException {
        try{
            double result = 0.0;                    // �ٷμ��װ���
            double limit  = 60 * MANWON ;           // �ѵ��� 60 ����

            // ���⼼���� 50���������� ���
            if( _���⼼��  <= ( 50*MANWON ) ){
                result = _���⼼�� * 0.45 ;

            // ���⼼���� 50�����ʰ��� ���
            } else if( _���⼼�� > ( 50*MANWON ) ){
                result = (22.5*MANWON) + ((_���⼼��-( 50*MANWON )) * 0.3 ) ;
            }

            //return result ;
            data._�ٷμ��װ��� = ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �������� ��� .. 
    public void set��������() throws GeneralException {
        try{
            data._�������� = data._���⼼�� - get���װ�����() ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// _����ȯ�޾� ��� .. 
    public void set����ȯ�޾�() throws GeneralException {
        try{
            data._����ȯ�޾� = data._�������� - data._�ⳳ�μ��� ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*---------------------------------------------------------------------------*/
/*- �� �׸񺰷� �Ұ踦 ��� -------------------------------------------------*/
/*---------------------------------------------------------------------------*/

/*--- �������� �� -----------------------------------------------------------*/
    public double get����������() throws GeneralException {
        try{
Logger.debug.println(this, "�������� �� : "+data._���������Ѿ�);
            return data._���������Ѿ� ;
        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*--- Ư������ �� -----------------------------------------------------------*/
    public double getƯ��������() throws GeneralException {
        try{
            double minimum = 60 * MANWON ;      // ǥ�ذ��� 60����
            double total = 0.0;
            total += cal�ǷẸ���(data._�ǷẸ���)                                              ; // �ǷẸ��
            total += cal��뺸���(data._��뺸���)                                              ; // ��뺸��
            total += sum�����(data._������Ϲ�,data._����������)                                    ; // �����
            total += sum�Ƿ��(data._�Ƿ���Ϲ�+data._�Ƿ�������,data._�Ƿ�������)                                  ; // �Ƿ��
            total += sum�����ڱ�(data._�����ڱ�����ݾ�,data._�����ڱ����Կ�����,data._�����ڱ��������ڻ�ȯ); // �����ڱ�
            total += sum��α�(data._��αݹ���,data._��α�����)                                      ; // ��α�
            total += sum������()                                                             ; // ������
Logger.debug.println(this, "Ư������ �� : "+total);
            return ( (total < minimum) ? minimum : total ) ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*--- ��Ÿ���� �� -----------------------------------------------------------*/
    public double get��Ÿ������() throws GeneralException {
        try{
            double total = 0.0;
            total  = cal���ο���I(data._���ο���I)          ; // ���ο���I
            total += cal���ο���II( data._���ο���II)        ; // ���ο���II
            total += cal���ο���(data._���ο���)            ; // ���ο���
            total += cal�������հ���I(data._�������հ���I)  ; // �������հ���I
            total += cal�������հ���II(data._�������հ���II); // �������հ���II
            total += cal�ſ�ī�����(data._�ſ�ī�����)    ; // �ſ�ī��ҵ����
Logger.debug.println(this, "��Ÿ���� �� : "+total);
            return total ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*--- ���װ��� �� -----------------------------------------------------------*/
    public double get���װ�����() throws GeneralException {
        try{
            double total = 0.0;
            total  = data._�ٷμ��װ���                          ; // �ٷμҵ漼�װ���
            total += cal�����ڱ����ڻ�ȯ(data._�����ڱ����ڻ�ȯ) ; // cal�����ڱ����ڻ�ȯ
            total += cal�ٷ����ֽ�����(data._�ٷ����ֽ�����)     ; // cal�ٷ����ֽ�����
            total += cal�����������(data._�����������)         ; // cal�����������
            total += cal�ܱ����μ����(data._�ܱ����μ����,data._�ܱ����μ��̿���); // cal�ܱ����μ����
Logger.debug.println(this, "���װ��� �� : "+total);
            return total ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*---------------------------------------------------------------------------*/

// ��������� �Ұ�   ???
    public double sum������() throws GeneralException {
        try{
            double total = 0.0;
            total  = cal��������(data._��������)    ; // ��������   
            total += cal����������(data._����������); // ����������
            total += cal���������߰�(data._���������߰�); // ���������߰�
            total += cal���������(data._���������)    ; // ���������
Logger.debug.println(this, "��������� �Ұ� : "+total);
            return total;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �������� �Ұ�
    public double sum�����(double _������Ϲ�, double _����������) throws GeneralException {
        try{
Logger.debug.println(this, "�������� �Ұ� : "+( cal������Ϲ�(_������Ϲ�) + cal����������(_����������) ));
            return ( cal������Ϲ�(_������Ϲ�) + cal����������(_����������) );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �Ƿ����� �Ұ�
    public double sum�Ƿ��(double _�Ƿ���Ϲ�, double _�Ƿ�������) throws GeneralException {
        try{
Logger.debug.println(this, "�Ƿ����� �Ұ� : "+( cal�Ƿ���Ϲ�(_�Ƿ���Ϲ�)+"+"+cal�Ƿ�������(_�Ƿ���Ϲ�, _�Ƿ�������) )+"="+( cal�Ƿ���Ϲ�(_�Ƿ���Ϲ�) + cal�Ƿ�������(_�Ƿ���Ϲ�, _�Ƿ�������) ));
            return ( cal�Ƿ���Ϲ�(_�Ƿ���Ϲ�) + cal�Ƿ�������(_�Ƿ���Ϲ�, _�Ƿ�������) );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �����ڱݰ��� �Ұ�
    public double sum�����ڱ�(double _�����ڱ�����ݾ�, double _�����ڱ����Կ�����, double _�����ڱ��������ڻ�ȯ) throws GeneralException {
        try{
            double limit   = 300 * MANWON ;  // �ѵ��� 300����

            double sum�����ڱ� = cal�����ڱ�����ݾ�( _�����ڱ�����ݾ�) + cal�����ڱ����Կ�����( _�����ڱ����Կ�����) + cal�����ڱ��������ڻ�ȯ( _�����ڱ��������ڻ�ȯ) ;
Logger.debug.println(this, "�����ڱݰ��� �Ұ� : "+( (sum�����ڱ� > limit) ? limit : sum�����ڱ� ));
            return ( (sum�����ڱ� > limit) ? limit : sum�����ڱ� );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ��α�Ư������
    public double sum��α�(double _��αݹ���, double _��α�����) throws GeneralException {
        try{
Logger.debug.println(this, "��α�Ư������ : "+( cal��αݹ���(_��αݹ���) + cal��α�����(_��αݹ���, _��α�����) ));
            return ( cal��αݹ���(_��αݹ���) + cal��α�����(_��αݹ���, _��α�����) );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }

/*---------------------------------------------------------------------------*/
/*- �� �����׸񺰷� ���������ݾ� ����ؼ� return �ϴ� method �� -------------*/
/*---------------------------------------------------------------------------*/

// �ǷẸ��
    public double cal�ǷẸ���(double _�ǷẸ���) throws GeneralException {
        try{

Logger.debug.println(this, "�ǷẸ�� : "+_�ǷẸ���);
            return _�ǷẸ��� ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ��뺸��
    public double cal��뺸���(double _��뺸���) throws GeneralException {
        try{

Logger.debug.println(this, "��뺸�� : "+_��뺸���);
            return _��뺸��� ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �����(�Ϲ�).. ���强 �����
    public double cal������Ϲ�(double _������Ϲ�) throws GeneralException {
        try{
            double limit   = 70 * MANWON ;  // �ѵ��� 70����

            double result = _������Ϲ� ;
Logger.debug.println(this, "�����(�Ϲ�).. ���强 ����� : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �����(�����)
    public double cal����������(double _����������) throws GeneralException {
        try{
            double limit   = 100 * MANWON ;  // �ѵ��� 100����

            double result = _���������� ;
Logger.debug.println(this, "�����(�����) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �Ƿ��(�Ϲ�) ... �Ƿ�����޾� - (�ٷμҵ���Աݾ� * 3 %) 
    public double cal�Ƿ���Ϲ�(double _�Ƿ���Ϲ�) throws GeneralException {
        try{
            double limit   = 300 * MANWON ;  // �ѵ��� 300����
            double percent = 0.03         ;  // 3 %

            double result = _�Ƿ���Ϲ� - (data._�������ٷμҵ� * percent) ;
            if(result < 0) result = 0 ;
Logger.debug.println(this, "�Ƿ��(�Ϲ�) ... �Ƿ�����޾� - (�ٷμҵ���Աݾ� * 3 %) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �Ƿ��(���+���)
// ��ο���� �� ����� ��Ȱ�Ƿ�� ���� �� �����ÿ��� �������� 200���� �ʰ��װ� 
// �Ƿ���� ��Ȱ�Ƿ�� �� ���� �ݾ��� �߰�����
    public double cal�Ƿ�������(double _�Ƿ���Ϲ�, double _�Ƿ�������) throws GeneralException {
        try{
            double old_result = cal�Ƿ���Ϲ�(_�Ƿ���Ϲ�) ;
            
            double extra = old_result - (200 * MANWON) ;
            double result = ( (extra > _�Ƿ�������) ? _�Ƿ������� : extra );
            if(result < 0) result = 0 ;
Logger.debug.println(this, "�Ƿ��(���+���) : "+result);
            return result;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �����ڱ�(����ݾ�)
    public double cal�����ڱ�����ݾ�(double _�����ڱ�����ݾ�) throws GeneralException {
        try{
            double percent = 0.4         ;  // 40 %

            double result = _�����ڱ�����ݾ� * percent ;
Logger.debug.println(this, "�����ڱ�(����ݾ�) : "+result);
            return result ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �����ڱ�(���Կ�����)
    public double cal�����ڱ����Կ�����(double _�����ڱ����Կ�����) throws GeneralException {
        try{
            double percent = 0.4         ;  // 40 %

            double result = _�����ڱ����Կ����� * percent ;
Logger.debug.println(this, "�����ڱ�(���Կ�����) : "+result);
            return result ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �����ڱ�(�������ڻ�ȯ).. ��������
    public double cal�����ڱ��������ڻ�ȯ(double _�����ڱ��������ڻ�ȯ) throws GeneralException {
        try{
            double percent = 1.0         ;  // 100 %

            double result = _�����ڱ��������ڻ�ȯ * percent ;
Logger.debug.println(this, "�����ڱ�(�������ڻ�ȯ) : "+result);
            return result ;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ��α�(����)
    public double cal��αݹ���(double _��αݹ���) throws GeneralException {
        try{

Logger.debug.println(this, "��α�(����) : "+_��αݹ���);
            return _��αݹ���;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ��α�(����)
    public double cal��α�����(double _��αݹ���, double _��α�����) throws GeneralException {
        try{
            double percent = 0.1         ;  // 10 %
            double limit   = (data._�ٷμҵ�ݾ� - cal��αݹ���(_��αݹ���) ) * percent ;  // �ѵ��� 

            double result = _��α����� ;
Logger.debug.println(this, "��α�(����) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ������ ����
    public double cal��������(double _��������) throws GeneralException {
        try{
            
Logger.debug.println(this, "������ ���� : "+_��������);
            return _��������;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ������ �ξ簡��(������)
    public double cal����������(double _����������) throws GeneralException {
        try{
            double limit   = 100 * MANWON ;  // �ѵ��� 100����
            double result = _���������� ;
Logger.debug.println(this, "������ �ξ簡��(������) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ������ �ξ簡��(���߰�)
    public double cal���������߰�(double _���������߰�) throws GeneralException {
        try{
            double limit   = 150* MANWON ;  // �ѵ��� 150����
            double result = _���������߰� ;
Logger.debug.println(this, "������ �ξ簡��(���߰�) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ������ �ξ簡��(����)
    public double cal���������(double _���������) throws GeneralException {
        try{
            double limit   = 300 * MANWON ;  // �ѵ��� 300����
            double result = _��������� ;
Logger.debug.println(this, "������ �ξ簡��(����) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ���ο��� I... ? ���ο��ݰ��� ���ؿ��� ���Ծ��� 40%����(�ѵ� 72����)
    public double cal���ο���I(double _���ο���I) throws GeneralException {
        try{
            double percent = 0.4         ;  // ���ؿ��� ���Ծ��� 40%����
            double limit   = 72 * MANWON ;  // �ѵ��� 72����

            double result = _���ο���I * percent ;
Logger.debug.println(this, "���ο��� I : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ���ο��� II... ? ����������� �ѵ� 240����
    public double cal���ο���II(double _���ο���II) throws GeneralException {
        try{
            double limit   = 240 * MANWON  ;  // �ѵ��� 240����

            double result = _���ο���II ;
Logger.debug.println(this, "���ο��� II : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// ���ο���
    public double cal���ο���(double _���ο���) throws GeneralException {
        try{
            double percent = 0.5         ;  // ���ο��� ���κδ���� 50%

            double result = _���ο��� * percent ;
Logger.debug.println(this, "���ο��� : "+result);
            return result;

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �������հ��� I .. 1999.08.31 ���� ���ں� �����ؼ� 20% ����
    public double cal�������հ���I(double _�������հ���I) throws GeneralException {
        try{
            double percent = 0.2         ;  // 20% ����
            double limit   = data._�ٷμҵ�ݾ� * 0.7 ;  // ���� �������� �ٷ�(����)�ҵ�ݾ��� 70%

            double result = _�������հ���I * percent ;
Logger.debug.println(this, "�������հ��� I  : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �������հ��� II 
    public double cal�������հ���II(double _�������հ���II) throws GeneralException {
        try{
            double percent = 0.3         ;  // ���ھ��� 30% ����
            double limit   = data._�ٷμҵ�ݾ� * 0.7 ;  // ���� �������� �ٷ�(����)�ҵ�ݾ��� 70%

            double result = _�������հ���II * percent ;
Logger.debug.println(this, "�������հ��� II : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �ſ�ī�����
    public double cal�ſ�ī�����(double _�ſ�ī�����) throws GeneralException {
        try{
            double cardWon = _�ſ�ī����� - (data._�ѱ޿� * 0.1) ;  // �ſ�ī����ݾ� - �ѱ޿��� 10%
            if( cardWon <= 0 ){
Logger.debug.println(this, "�ſ�ī����� : 0.0");
                return 0.0;
            } else {
                double percent = 0.2          ;  // 20% ����
                double limit   = 500 * MANWON ;  // �ѵ��� 500������ �ѱ޿��� 20% �� �����ݾ�
                limit = ( (limit > (data._�ѱ޿� * 0.2) ) ? (data._�ѱ޿� * 0.2) : limit );

                double result = cardWon * percent ;
Logger.debug.println(this, "�ſ�ī����� : "+( (result > limit) ? limit : result ));
                return ( (result > limit) ? limit : result );
            }
        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �����ڱ����ڻ�ȯ
    public double cal�����ڱ����ڻ�ȯ(double _�����ڱ����ڻ�ȯ) throws GeneralException {
        try{
            double percent = 0.3         ;  // ���ڻ�ȯ���� 30%
            double limit = data._���⼼�� ;
            double result = _�����ڱ����ڻ�ȯ * percent ;
Logger.debug.println(this, "�����ڱ����ڻ�ȯ : "+result);
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �ٷ����ֽ�����
    public double cal�ٷ����ֽ�����(double _�ٷ����ֽ�����) throws GeneralException {
        try{
            double percent = 0.05         ;  // 5%
            double limit = data._���⼼�� ;
            double result = _�ٷ����ֽ����� * percent ;
Logger.debug.println(this, "�ٷ����ֽ����� : "+result);
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �����������
    public double cal�����������(double _�����������) throws GeneralException {
        try{
            double percent = 0.05         ;  // 5 %
            double limit = data._���⼼�� ;
            double result = _����������� * percent ;
Logger.debug.println(this, "����������� : "+result);
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
// �ܱ����μ�(���), �ܱ����μ�(�̿���)
    public double cal�ܱ����μ����(double _�ܱ����μ����, double _�ܱ����μ��̿���) throws GeneralException {
        try{
            double limit = 0.0 ;
            if(data._�ٷμҵ�ݾ� != 0){
                limit = data._���⼼�� * ( data._���ܿ�õ�ٷμҵ�ݾ� / data._�ٷμҵ�ݾ� ) ; // 
            }
            double result = (_�ܱ����μ���� + _�ܱ����μ��̿���) ;
Logger.debug.println(this,"data._���ܿ�õ�ٷμҵ�ݾ� : "+ data._���ܿ�õ�ٷμҵ�ݾ�);
Logger.debug.println(this,"data._�ٷμҵ�ݾ� : "+ data._�ٷμҵ�ݾ�);
Logger.debug.println(this,"data._���⼼�� : "+data._���⼼��);
Logger.debug.println(this,"limit : "+ limit);
Logger.debug.println(this,"result : "+ result);
Logger.debug.println(this,(result > limit)+"" );
Logger.debug.println(this, "�ܱ����μ�(���), �ܱ����μ�(�̿���) : "+( (result > limit) ? limit : result ));
            return ( (result > limit) ? limit : result );

        } catch(Exception ex){
            throw new GeneralException(ex);
        }
    }
/*---------------------------------------------------------------------------*/
}
