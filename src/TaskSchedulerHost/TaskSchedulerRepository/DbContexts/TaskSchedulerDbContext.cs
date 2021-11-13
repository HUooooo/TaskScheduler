﻿using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using TaskSchedulerModel.Models;

namespace TaskSchedulerRepository.DbContexts
{
    public class TaskSchedulerDbContext : DbContext
    {

        public TaskSchedulerDbContext()
        { 
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer("server=106.52.231.133;Database=TaskScheduler;uid=sa;pwd=Lkl888888");
        }

        public TaskSchedulerDbContext(DbContextOptions options) : base(options)
        {
            //数据库迁移命令：Add-Migration InitialCreate；Update-Database
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            //modelBuilder.UseIdentityColumns(1,1);
            modelBuilder.ForSqlServerUseIdentityColumns();

            modelBuilder.Entity<TaskInfo>().Property(l => l.WriteTime).HasDefaultValueSql("getdate()");
            modelBuilder.Entity<TaskInfo>().Property(l => l.UpdateTime).HasDefaultValueSql("getdate()");
            modelBuilder.Entity<TaskInfo>().Property(l => l.TaskGuid).HasDefaultValueSql("newid()");

            modelBuilder.Entity<TaskCommandInfo>().Property(l => l.WriteTime).HasDefaultValueSql("getdate()");
            modelBuilder.Entity<TaskCommandInfo>().HasIndex(n => n.TaskId);

            modelBuilder.Entity<TaskConfig>().Property(l => l.WriteTime).HasDefaultValueSql("getdate()");
            modelBuilder.Entity<TaskConfig>().HasIndex(n => n.TaskId);

        }

        public virtual DbSet<TaskInfo> TaskInfos { get; set; }
        public virtual DbSet<LogInfo> LogInfos { get; set; }
        public virtual DbSet<TaskCommandInfo> TaskCommandInfos { get; set; }

        public virtual DbSet<TaskConfig> TaskConfigs { get; set; }
        public virtual DbSet<UserInfo> UserInfos { get; set; }
        public virtual DbSet<TaskManage> TaskManages { get; set; }
    }
}
