package com.zenithbank.banking.coporate.ibank.payment;

import com.zenithbank.banking.ibank.common.BaseAdapter;
import java.io.PrintStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class MoveUserAdapter extends BaseAdapter
{

    private Connection _$23961;
    private CallableStatement _$23982;
    private ResultSet _$21391;
    private Statement _$23987;
    private PreparedStatement _$21171;
    private Connection _$23988;
    private SimpleDateFormat _$23995;
    private String _$23997;

    public MoveUserAdapter()
    {
        _$23961 = null;
        _$21391 = null;
        _$23997 = null;
    }

    public String getCurrentHostCompany(String loginid)
    {
        String hostcompany = "";
        String selecttSql = " Select HOSTCOMPANY from ZenBaseNet..ZIB_CIB_GB_LOGIN where LOGINID = '" + loginid + "'";
        try
        {
            _$23961 = getConnection();
            _$21171 = _$23961.prepareStatement(selecttSql);
            _$21391 = _$21171.executeQuery();
            if(_$21391.next())
            {
                hostcompany = _$21391.getString("HOSTCOMPANY");
            }
        }
        catch(Exception ee)
        {
            System.out.println("Error geting hostcompany: " + ee);
            ee.printStackTrace();
        }
        finally
        {
            if(_$23961 != null)
            {
                try
                {
                    _$23961.close();
                }
                catch(Exception exception1) { }
            }
        }
        return hostcompany;
    }

    public int UpdateProfile(String hostcompany, String modifyby, String loginid, String approve)
    {
        int k = 0;
        MoveUserAdapter dup = new MoveUserAdapter();
        if(dup.getCurrentHostCompany(loginid).equals(hostcompany))
        {
            return 10;
        }
        long time = Calendar.getInstance().getTime().getTime();
        String updateUser = "UPDATE ZenBaseNet..ZIB_CIB_GB_LOGIN";
        updateUser = updateUser + " SET HOSTCOMPANY = '" + hostcompany + "' ,";
        updateUser = updateUser + "MODIFIEDBY = '" + modifyby + "' ,";
        updateUser = updateUser + "MODIFIEDDT = '" + new Date(time) + "' ,";
        updateUser = updateUser + "AUTHORISATION = '0' ,";
        updateUser = updateUser + "APPROVAL_OFFICER = '" + approve + "' ,";
        updateUser = updateUser + "PASSCHANGE = '1'";
        updateUser = updateUser + " WHERE LOGINID = '" + loginid + "'";
        try
        {
            _$23961 = getConnection();
            _$23987 = _$23961.createStatement(1004, 1007);
            k = _$23987.executeUpdate(updateUser);
        }
        catch(Exception ee)
        {
            System.out.println("Error connecting: " + ee);
            ee.printStackTrace();
        }
        finally
        {
            if(_$23961 != null)
            {
                try
                {
                    _$23961.close();
                }
                catch(Exception exception1) { }
            }
        }
        return k;
    }
}
