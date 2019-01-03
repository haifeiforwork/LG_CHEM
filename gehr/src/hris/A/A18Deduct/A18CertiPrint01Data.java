package hris.A.A18Deduct ;

/**
 * A18CertiPrint01Data.java
 * �ٷμҵ��õ¡��������:T_RESULT
 * [RFC] ,ZHRP_RFC_READ_YEA_RESULT_PRINT
 * 
 * @author  �赵�� 
 * @version 1.0, 2005/09/29
 */
public class A18CertiPrint01Data extends com.sns.jdf.EntityData {

    public double _�޿��Ѿ�                   ; // "/Y1A"
    public double _���Ѿ�                   ; // "/Y1B"
    public double _������                   ; // "/Y1C"
    public double _�ֽĸż����ñ�������� ; // "/Y18" 09.02.03 add   
    public double _�츮������������� ; // "/Y22" 10.02.04 add   
    public double _�������հ��� ; // "/Y7V" 10.02.04 add   

    public double _������ҵ�_����Ȱ����      ; // "/Y1K"  09.02.03 add
    public double _������ҵ�_��꺸������      ; // "/Y16"  09.02.03 add
    public double _������ҵ�_�ܱ��αٷ���      ; // "/Y15"  09.02.03 add
     
    public double _������ҵ�_���ܱٷ�        ; // "/Y1G"
    public double _������ҵ�_�߰��ٷμ���    ; // "/Y1E"
    public double _������ҵ�_��Ÿ�����      ; // "/Y1F"
    public double _������ҵ�_�հ�            ; // ������ҵ� �հ�

    public double _�ѱ޿�                     ; // "/Y1T"
    public double _�ٷμҵ����               ; // "/Y2D"
    public double _�ٷμҵ�ݾ�               ; // "/Y2E"
// ���ռҵ�ݾ�-�⺻����
    public double _�⺻����_����              ; // "/Y3E"
    public double _�⺻����_�����            ; // "/Y3G"
    public double _�⺻����_�ξ簡��          ; // "/Y3P"
// ���ռҵ�ݾ�-�߰�����
    public double _�߰�����_��ο��          ; // "/Y3S" + "/Y3U"
    public double _�߰�����_�����            ; // "/Y3T"
    public double _�߰�����_�γ���            ; // "/Y3V"
    public double _�߰�����_�ڳ������        ; // "/Y3X"
    public double _�߰�����_����Ծ���        ; // "/Y3W"  09.02.03 add
// �Ҽ��������߰�����
    public double _�Ҽ��������߰�����         ; // "/Y3Z"
// ���ݺ�������
    public double _���ݺ�������             ; // "/Y6A"
    public double _���ο��ݺ�������        ; // "=/Y6A - /Y6N"  09.02.03 add
    public double _��Ÿ���ݺ�������        ; // "/Y6N"  09.02.03 add
    public double _�������ݼҵ����           ; // "/Y6S"  09.02.03 add
// ���ռҵ�ݾ�-Ư������
    public double _Ư������_�����            ; // "/Y4C"
    public double _Ư������_�Ƿ��            ; // "/Y4H"
    public double _Ư������_������            ; // "/Y4M"
    public double _Ư������_�����ڱ�          ; // "/Y5G"
    public double _Ư������_��������������Ա����ڻ�ȯ��; // "/Y54"  09.02.03 add
    public double _Ư������_�����������Աݿ����ݻ�ȯ��   ; // "/Y5L"  09.02.03 add
    public double _Ư������_��α�            ; // "/Y5S(��αݰ������)" = "/Y5N(������α�)" + "/Y5R(������α�)"
    public double _Ư������_ȥ���̻���ʺ�    ; // "/Y5U"
    public double _Ư������_��                ; // Ư������ �հ�
// ǥ�ذ���
    public double _ǥ�ذ���                   ; // "/Y5Z"
// �����ҵ�ݾ�
    public double _�����ҵ�ݾ�               ; // _�ٷμҵ�ݾ� - ���ռҵ�ݾ� �հ�
// ��Ư�ҵ����
    public double _Y6B       ; // "/Y6B"
    public double _���ο�������ҵ����       ; // "/Y6I"
    public double _��������ҵ����           ; // "/Y6Q"
    public double _�����������ڵ�ҵ����     ; // "/Y6V"
    public double _�ſ�ī�����               ; // "/Y6M"
    public double _�һ���ΰ����αݼҵ����; // "/Y7U"  09.02.03 add
    public double _���ø�������ҵ����; // "/Y5E"  09.02.03 add
    public double _����ֽ�������ҵ����; // "/Y7W"  09.02.03 add
    public double _�׹��Ǽҵ������; // "/Y7W"  09.02.03 add
    
// ���ռҵ����ǥ��
    public double _���ռҵ����ǥ��           ; // "/Y7B"
// ���⼼��
    public double _���⼼��                   ; // "/Y7C"
// ���װ���
    public double _���װ���_�ҵ漼������      ; // "/Y7Q"
    public double _���װ���_����Ư�����ѹ�    ; // "/Y7R"
    public double _���װ���_���鼼�װ�        ; // ���װ��� �հ�
// ���װ���
    public double _���װ���_�ٷμҵ�          ; // "/Y7E"
    public double _���װ���_�������Ա�        ; // "/Y7G"
    public double _���װ���_�ٷ����ֽ�����    ; // "/Y7I"
    public double _���װ���_�ܱ�����          ; // "/Y7M"
    public double _���װ���_�����ġ�ڱ�   		; // "/Y7N"
    public double _���װ���_���װ�����        ; // ���װ��� �հ�
    
    public double _��������_���ټ�            ; // "/Y8I"
    public double _��������_�ֹμ�            ; // "/Y8R"
    public double _��������_��Ư��            ; // "/Y8S"
    public double _��������_�հ�              ; // �������� �հ�    
    public double _�ⳳ�μ���_���ټ�          ; // "/Y9I"
    public double _�ⳳ�μ���_�ֹμ�          ; // "/Y9R"
    public double _�ⳳ�μ���_��Ư��          ; // "/Y9S"
    public double _�ⳳ�μ���_�հ�            ; // �ⳳ�μ��� �հ�  

    public double _����_�ҵ漼          ; // "/P03"  09.02.03 add    
    public double _����_�ֹμ�          ; // "/P04" 09.02.03 add     
    public double _����_�հ�            ; // �ⳳ�μ��� �հ�    09.02.03 add
    
    
    public double _����¡������_���ټ�        ; // "/YAI"
    public double _����¡������_�ֹμ�        ; // "/YAR"
    public double _����¡������_��Ư��        ; // "/YAS"
    public double _����¡������_�հ�          ; // ����¡������ �հ�
// �ǰ�����, ��뺸��
    public double _�ǰ�����                   ; // "/Y42"
    public double _��뺸��                   ; // "/Y44"
}
