package com.zenithbank.merchantclient;

import org.quartz.CronScheduleBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;

import org.quartz.Trigger;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

public class MerchantClient {
	static Scheduler scheduler = null;
	private static final Logger logger = LoggerFactory.getLogger(MerchantClient.class);
	private static LoadPropFile propFile = LoadPropFile.getInstance();
	public static void main(String[] args) throws Exception {
		JobDetail job = newJob(MerchantNotificationJob.class).withIdentity("CronQuartzJob", "Group").build();
		String cronTimer = propFile.getCronTimer();
		logger.info("Cront timer used :: " + cronTimer);

		Trigger trigger;

		trigger = newTrigger().withIdentity("MerchantNotificationTrigger", "Group")
				.withSchedule(CronScheduleBuilder.cronSchedule(cronTimer)).build();

		// Setup the Job and Trigger with Scheduler & schedule jobs
		scheduler = new StdSchedulerFactory().getScheduler();
		scheduler.start();
		scheduler.scheduleJob(job, trigger);

	}
}
