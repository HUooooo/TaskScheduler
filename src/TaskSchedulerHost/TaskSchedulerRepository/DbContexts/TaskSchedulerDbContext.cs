﻿using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using TaskSchedulerModel.Models;

namespace TaskSchedulerRepository.DbContexts
{
    public class TaskSchedulerDbContext : DbContext
    {
        public TaskSchedulerDbContext(DbContextOptions options) :base(options)
        {
            //数据库迁移命令：Add-Migration InitialCreate；Update-Database
        }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.UseIdentityColumns(1,1);
            modelBuilder.Entity<TaskInfo>().Property(l => l.WriteTime).HasDefaultValueSql("getdate()");
            modelBuilder.Entity<TaskInfo>().Property(l => l.UpdateTime).HasDefaultValueSql("getdate()");
            modelBuilder.Entity<TaskInfo>().Property(l => l.TaskGuid).HasDefaultValueSql("newid()");

            modelBuilder.Entity<TaskCommandInfo>().Property(l => l.WriteTime).HasDefaultValueSql("getdate()");
            modelBuilder.Entity<TaskCommandInfo>().HasIndex(n=>n.TaskId);

            modelBuilder.Entity<TaskConfig>().Property(l => l.WriteTime).HasDefaultValueSql("getdate()");
            modelBuilder.Entity<TaskConfig>().HasIndex(n => n.TaskId);
        }

        public virtual DbSet<TaskInfo> TaskInfos { get; set; }
        public virtual DbSet<LogInfo> LogInfos { get; set; }
        public virtual DbSet<TaskCommandInfo> TaskCommandInfos { get; set; }

        public virtual DbSet<TaskConfig> TaskConfigs { get; set; }
    }
}
