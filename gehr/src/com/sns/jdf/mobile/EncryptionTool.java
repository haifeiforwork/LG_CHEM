// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) lnc radix(10) lradix(10)
// Source File Name:   EncryptionTool.java

package com.sns.jdf.mobile;

import java.io.IOException;
import java.lang.reflect.Method;
import java.util.Arrays;
import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;

import com.sns.jdf.*;

//import  com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

//import  org.apache.xerces.impl.xs.util.Base64 ;

//import com.ibm.util.Base64 ;
//import com.octetstring.vde.util.Base64;

// Referenced classes of package com.funambol.framework.tools.encryption:
//            EncryptionException

public class EncryptionTool
{

    public EncryptionTool()
    {
    }

    public static byte[] encrypt(byte plainBytes[], byte encryptionKey[])
        throws EncryptionException
    {
    	Logger.debug.println("encrypt byte" );
/* 148*/        if(plainBytes == null)
/* 149*/            return null;
/* 151*/        if(encryptionKey == null)
/* 152*/            throw new IllegalArgumentException("The key can not be null");
/* 155*/        byte cipherBytes[] = null;
/* 157*/        try
        {
/* 157*/            encryptionKey = paddingKey(encryptionKey, 24, (byte)0);
/* 159*/            java.security.spec.KeySpec keySpec = new DESedeKeySpec(encryptionKey);
/* 160*/            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DESEde");
/* 161*/            Cipher cipher = Cipher.getInstance("DESEde");
/* 163*/            javax.crypto.SecretKey key = keyFactory.generateSecret(keySpec);
/* 164*/            cipher.init(1, key);
/* 166*/            cipherBytes = cipher.doFinal(plainBytes);

        }
/* 167*/        catch(Exception e)
        {
					Logger.error(e);
					 Logger.debug.println("encryptbyte999 :"+e.getMessage() );
/* 168*/            throw new EncryptionException("Error encrypting", e);
        }
Logger.debug.println("encrypt byte888:"+cipherBytes );
/* 171*/        return cipherBytes;
    }

    public static byte[] encrypt(byte plainBytes[])
        throws EncryptionException
    {
    	
/* 181*/        return encrypt(plainBytes, DEFAULT_KEY);
    }

    public static String encrypt(String plainText, byte key[])
        throws EncryptionException
    {
    	Logger.debug.println("encrypt in2" );
    	 try{
/* 192*/        if(plainText == null)
/* 193*/            return null;
/* 195*/        if(key == null){
/* 196*/            throw new IllegalArgumentException("The key can not be null");
/* 199*/       } else
				{	
	             Logger.debug.println("plainText:"+plainText );
	             String testString = new String(Base64.encode(encrypt(plainText.getBytes(), key)));
	             //String testString = Base64.encode(encrypt(plainText.getBytes(), key));
	             //testString = Base64.encode(encrypt(plainText.getBytes(), key)).toString();
	            // String testString = new String(encrypt(plainText.getBytes(), key));
				Logger.debug.println("testString:"+testString );
				/* 199*/return testString ;
				}
    	 }catch(Exception e)
    	 {
    		 Logger.error(e);
    		 Logger.debug.println("encrypt Exception"+e.getMessage() );
    		 /* 168*/            throw new EncryptionException("Error encrypting", e);
		 }	
    }

    public static String encrypt(String plainText)
        throws EncryptionException
    {
    	Logger.debug.println("encrypt in1" );
/* 209*/        return encrypt(plainText, DEFAULT_KEY);
    }

    public static byte[] decrypt(byte encryptedBytes[], byte encryptionKey[])
        throws EncryptionException
    {
/* 222*/        if(encryptedBytes == null)
/* 223*/            return null;
/* 225*/        if(encryptionKey == null)
/* 226*/            throw new IllegalArgumentException("The key can not be null");
/* 228*/        byte plainBytes[] = null;
/* 230*/        try
        {
/* 230*/            encryptionKey = paddingKey(encryptionKey, 24, (byte)0);
/* 232*/            java.security.spec.KeySpec keySpec = new DESedeKeySpec(encryptionKey);
/* 233*/            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DESEde");
/* 234*/            Cipher cipher = Cipher.getInstance("DESEde");
/* 236*/            javax.crypto.SecretKey key = keyFactory.generateSecret(keySpec);
/* 237*/            cipher.init(2, key);
/* 239*/            plainBytes = cipher.doFinal(encryptedBytes);
        }
/* 240*/        catch(Exception e)
        {
/* 241*/            throw new EncryptionException("Error decrypting", e);
        }
/* 244*/        return plainBytes;
    }

    public static byte[] decrypt(byte encryptedBytes[])
        throws EncryptionException
    {
/* 254*/        return decrypt(encryptedBytes, DEFAULT_KEY);
    }

    public static String decrypt(String encryptedText)
        throws EncryptionException
    {
/* 264*/        if(encryptedText == null)
/* 265*/            return null;
/* 267*/        else
/* 267*/            return new String(decrypt(Base64.decode(encryptedText), DEFAULT_KEY));
    }

    public static String decrypt(String encryptedText, byte key[])
        throws EncryptionException
    {
/* 278*/        if(encryptedText == null)
/* 279*/            return null;
/* 281*/        else
/* 281*/            return new String(decrypt(Base64.decode(encryptedText), key));
    }

    private static byte[] paddingKey(byte b[], int len, byte paddingValue)
    {
/* 295*/        byte newValue[] = new byte[len];
/* 297*/        if(b == null)
/* 302*/            return newValue;
/* 305*/        if(b.length >= len)
        {
/* 306*/            System.arraycopy(b, 0, newValue, 0, len);
/* 307*/            return newValue;
        } else
        {
/* 310*/            System.arraycopy(b, 0, newValue, 0, b.length);
/* 311*/            Arrays.fill(newValue, b.length, len, paddingValue);
/* 312*/            return newValue;
        }
    }

    private static final String ALGORITHM = "DESEde";
    private static final byte PADDING_VALUE = 0;
    private static final byte KEY_LENGTH = 24;
    private static final byte DEFAULT_KEY[];
    private static final String DEFAULT_STRING_KEY = "Omnia Gallia in tres partes divida est";

    static
    {
/*  87*/        String d = "Omnia Gallia in tres partes divida est";
/*  88*/        byte key[] = d.getBytes();
/*  89*/        Class cls = null;
/*  90*/        Object c = null;
/*  91*/        Method m = null;
/*  93*/        boolean providerClassFound = false;
/*  94*/        boolean providerMethodFound = false;
/*  97*/        try
        {
/*  97*/            cls = Class.forName("com.funambol.framework.tools.encryption.EncryptionKeyProvider");
/*  98*/            c = cls.newInstance();
/*  99*/            providerClassFound = true;
        }
/* 100*/        catch(Exception e)
        {
        }
/* 106*/        if(providerClassFound)
/* 108*/            try
            {
/* 108*/                Class parameters[] = null;
/* 109*/                m = cls.getMethod("get", parameters);
/* 110*/                providerMethodFound = true;
            }
/* 111*/            catch(Exception e)
            {
            }
/* 118*/        if(providerMethodFound)
        {
/* 119*/            byte retval[] = null;
/* 121*/            try
            {
/* 121*/                Object arglist[] = null;
/* 122*/                Object retobj = m.invoke(c, arglist);
/* 123*/                retval = (byte[])(byte[])retobj;
/* 124*/                key = retval;
            }
/* 128*/            catch(Exception e)
            {

            }
        }
/* 135*/        DEFAULT_KEY = paddingKey(key, 24, (byte)0);
    }
}
