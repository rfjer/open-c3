create database ci;
use ci;

create table `openc3_ci_project`(
`id`            int(16) unsigned not null primary key auto_increment comment 'id',

`status` VARCHAR(2) comment '状态', #0,1

`autofindtags` VARCHAR(2) comment '自动找tags', #0,1
`callonlineenv` VARCHAR(2) comment '触发线上套餐发布', #0,1
`calltestenv` VARCHAR(2) comment '触发测试套餐发布', #0,1
`findtags_at_once` VARCHAR(2) comment '立刻找tags', #0,1

`autobuild` VARCHAR(2) comment '自动build', #0,1
`name` VARCHAR(100) comment '名称',
`excuteflow` VARCHAR(100) comment '触发标准运维',
`calljobx` VARCHAR(100) comment '触发分批作业', 
`calljob` VARCHAR(100) comment '触发作业', 
`webhook` VARCHAR(2) comment '开启webhook', #0,1
`webhook_password` VARCHAR(30) comment 'webhook的密码',
`webhook_release` VARCHAR(128) comment 'webhook的分支',
`rely` VARCHAR(2) comment '是否有依赖', #0,1

`buildimage` VARCHAR(30) comment 'build镜像名', 
`buildscripts` VARCHAR(8000) comment '容器中构建的脚本',

`follow_up` VARCHAR(200) comment '后续调用的脚本', 
`follow_up_ticketid` VARCHAR(20) comment '票据编号',
`callback` VARCHAR(200) comment '回调地址',
`groupid` VARCHAR(50) comment '组名,和服务树id一致',

`tag_regex` VARCHAR(50) comment '正则表达式',

`addr` VARCHAR(200) comment '代码地址',
`ticketid` VARCHAR(20) comment '票据编号',

`notify` VARCHAR(200) comment '通知用户',


`slave` VARCHAR(40) comment 'slave',

`last_findtags` TIMESTAMP NOT NULL DEFAULT '1971-01-01 00:00:00' comment '最后检测时间',
`last_findtags_success` TIMESTAMP NOT NULL DEFAULT '1971-01-01 00:00:00' comment '最后检测成功时间',

`edit_user` VARCHAR(100) comment '最后编辑用户',
`edit_time` TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP comment '最后编辑时间',

`ci_type` VARCHAR(100) DEFAULT 'default' comment 'ci类型类型', #用于区分是否是k8s发布,是什么类型的发布，缺省情况下是default，如是k8s的deployment发布，则显示kubernetes
`ci_type_ticketid` VARCHAR(20) comment 'k8s集群票据编号',
`ci_type_kind` VARCHAR(200) comment 'k8s.kind',
`ci_type_namespace` VARCHAR(200) comment 'k8snamespace',
`ci_type_name` VARCHAR(200) comment '应用名称',
`ci_type_container` VARCHAR(200) comment 'container',
`ci_type_repository` VARCHAR(200) comment 'repository',
`ci_type_dockerfile` VARCHAR(200) comment 'dockerfile',
`ci_type_dockerfile_content` VARCHAR(3000) comment 'dockerfile_content'

)ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='项目';

create table `openc3_ci_rely`(
`id`            int(16) unsigned not null primary key auto_increment comment 'id',

`projectid` int(16) unsigned comment '项目id',
`path` VARCHAR(100) comment '路径',

`addr` VARCHAR(100) comment '仓库地址',
`ticketid` VARCHAR(20) comment '票据编号',
`tags` VARCHAR(200) comment '依赖的版本',
`edit_user` VARCHAR(50) comment '最后编辑用户',
`edit_time` TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP comment '最后编辑时间'
)ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='依赖';



create table `openc3_ci_repository`(
`id`            int(16) unsigned not null primary key auto_increment comment 'id',

`addr` VARCHAR(100) comment '仓库地址',
`type` VARCHAR(100) comment '仓库类型',
`username` VARCHAR(100) comment '用户名',
`password` VARCHAR(8000) comment '密码',
UNIQUE KEY `uniq_addr` (`addr`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='仓库';

create table `openc3_ci_ticket`(
`id`            int(16) unsigned not null primary key auto_increment comment 'id',
`name` VARCHAR(100) comment '名称',
`type` VARCHAR(100) comment '票据类型',
`share` VARCHAR(5000) comment '共享',
`ticket` VARCHAR(8000) comment '票据',
`describe` VARCHAR(2000) comment '描述',
`edit_user` VARCHAR(50) comment '最后编辑用户',
`create_user` VARCHAR(50) comment '创建用户',
`edit_time` TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP comment '最后编辑时间',
`create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP comment '创建时间',
UNIQUE KEY `uniq_name` (`name`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='票据';

create table `openc3_ci_images`(
`id`            int(16) unsigned not null primary key auto_increment comment 'id',
`name` VARCHAR(100) comment '名称',
`share` VARCHAR(100) comment '共享',
`describe` VARCHAR(2000) comment '描述',
`edit_user` VARCHAR(50) comment '最后编辑用户',
`create_user` VARCHAR(50) comment '创建用户',
`edit_time` TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP comment '最后编辑时间',
`create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP comment '创建时间'
)ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='容器镜像';

create table `openc3_ci_version`(
`id`            int(16) unsigned not null primary key auto_increment comment 'id',
`projectid` int(16) unsigned comment '项目id',

`uuid` VARCHAR(20) comment '唯一编号',
`name` VARCHAR(100) comment '版本名称',
`user` VARCHAR(100) comment '启动人',
`slave` VARCHAR(40) comment 'slave',
`status` VARCHAR(20) comment '状态',
`starttimems` VARCHAR(20) comment '开始时间包涵毫秒信息',
`finishtimems` VARCHAR(20) comment '结束时间包涵毫秒信息',
`starttime` VARCHAR(20) comment '开始时间',
`finishtime` VARCHAR(20) comment '结束时间',
`calltype` VARCHAR(100) comment '触发类型',
`pid` int(16) unsigned comment 'pid',
`runtime` VARCHAR(100) comment '任务总耗时',
`tagger` VARCHAR(100) comment 'tagger',
`taginfo` VARCHAR(200) comment 'taginfo',

`reason` VARCHAR(100) comment '成功或者失败的理由',

`create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP comment '创建时间',

UNIQUE KEY `uniq_projectid_name` (`projectid`,`name`),
UNIQUE KEY `uniq_uuid` (`uuid`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='版本';


create table `openc3_ci_keepalive`(
`id` int(16) unsigned not null primary key auto_increment comment 'id',
`slave` VARCHAR(40) comment 'slave',
`time` int(16) unsigned comment 'time',
UNIQUE KEY `uniq_slave` (`slave`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='slave心跳';

create table `openc3_ci_favorites`(
`id` int(16) unsigned not null primary key auto_increment comment 'id',
`ciid` int(16) unsigned comment 'ciid',
`name` VARCHAR(100) comment '别名',
`user` VARCHAR(100) comment '用户',
UNIQUE KEY `uniq_ciid_user` (`ciid`,`user`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='收藏夹';

create table `openc3_ci_assignment`(
`id` int(32) unsigned not null primary key auto_increment comment 'id',
`type` VARCHAR(200) comment '类型',
`name` VARCHAR(200) comment '任务名称',
`submitter` VARCHAR(100) comment '提交人',
`handler` VARCHAR(100) comment '处理人',
`url` VARCHAR(100) comment 'URL',
`method` VARCHAR(100) comment '方法',
`data` BLOB comment '数据',
`submit_reason` VARCHAR(100) comment '提交理由',
`handle_reason` VARCHAR(100) comment '处理结果',
`status` VARCHAR(20) comment '通知状态',
`remarks` BLOB comment '审批标注内容',
`create_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP comment '创建时间',
`finish_time` VARCHAR(20) comment '结束时间'
)ENGINE=InnoDB DEFAULT CHARSET=utf8 comment='assignment';
