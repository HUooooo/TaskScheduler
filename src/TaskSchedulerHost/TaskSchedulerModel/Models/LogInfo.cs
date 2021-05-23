﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TaskSchedulerModel.Models
{
    /// <summary>
    /// 普通日志
    /// </summary>
    [Table("t_log")]
    public class LogInfo : BaseModel
    {
        /// <summary>
        /// 任务ID
        /// </summary>
        public int TaskId { get; set; }
        
        /// <summary>
        /// 日志等级
        /// </summary>
        public LogLevel Level { get; set; }

        /// <summary>
        /// 日志信息
        /// </summary>
        [Column(TypeName = "varchar(max)")]
        [Required]
        public string Message { get; set; }

        /// <summary>
        /// 添加时间
        /// </summary>
        [Column(TypeName = "datetime")]
        public DateTime WriteTime { get; set; }

    }
}
