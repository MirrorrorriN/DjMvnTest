package com.Job;

import java.util.Date;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 * Created by Mirror on 17/7/21.
 */
public class SimpleJob implements Job {

    @Override
    public void execute(JobExecutionContext jobCtx)
            throws JobExecutionException {
        // TODO Auto-generated method stub
        System.out.println("Triggered. Time is " + new Date());
    }

}