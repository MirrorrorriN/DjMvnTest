package com.mybatis.test;

import com.Job.SimpleJob;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;
/**
 * Created by Mirror on 17/7/21.
 */
public class QuartzTest {
    public static void main(String[] args) {
        try {
            // Grab the Scheduler instance from the Factory
            Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();
            scheduler.start();

            // Job
            JobDetail job = JobBuilder.newJob(SimpleJob.class)
                    .withIdentity("myTrigger", "group1").build();

            // Trigger
            Trigger trigger = TriggerBuilder
                    .newTrigger()
                    .withIdentity("trigger1", "group1")
                    .startNow()
                    .withSchedule(
                            CronScheduleBuilder.cronSchedule("2,3,5,7 * * * * ?")).build();
//                            SimpleScheduleBuilder.simpleSchedule()
//                                    .withIntervalInSeconds(5).repeatForever())
//                    .build();


            scheduler.scheduleJob(job, trigger);
        } catch (SchedulerException se) {
            se.printStackTrace();
        }
    }
}
