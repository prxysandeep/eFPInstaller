,CREATE TABLE dbo.interface_transact ( 
trans_no             INT              NOT NULL, 
trans_date           smalldatetime,
trans_time           CHAR (8)             NOT NULL, 
vendor_code          CHAR (12)            NOT NULL, 
interface_id         INT              NOT NULL, 
unit_cost            DECIMAL (12,2)       NOT NULL, 
quantity             INT              NOT NULL, 
line_total           DECIMAL (12,2)       NOT NULL, 
uom                  CHAR (13)            NOT NULL, 
part_number          CHAR (25)            NOT NULL, 
man_part_number      CHAR (25)            NOT NULL, 
ship_flag            CHAR (1)             NOT NULL, 
shipping_amt         DECIMAL (12,2)       NOT NULL, 
requested_delivery   smalldatetime,
description          CHAR (255),
edit_flag            INT              NOT NULL, 
spi_req_no           CHAR (8), 
spi_req_line_no      SMALLINT, 
spi_po_no            CHAR (8), 
spi_po_line_no       SMALLINT, 
spi_empl_no          INT, 
spi_vend_no          CHAR (8), 
spi_key_orgn         CHAR (16), 
spi_account          CHAR (8), 
spi_project          CHAR (8), 
spi_proj_acct        CHAR (8), 
spi_commodity        CHAR (13), 
spi_status_flag      SMALLINT, 
spi_error_flag       SMALLINT             NOT NULL, 
spi_sent_cnt         SMALLINT             NOT NULL
);

CREATE TABLE dbo.interface_header ( 
interface_id         uniqueidentifier NOT NULL, 
interface_type       CHAR (12), 
interface_status     INT,
req_no               CHAR (8), 
location             CHAR (16), 
requested            smalldatetime,
require              smalldatetime,
ship_code            CHAR (8), 
rec_vend             CHAR (8), 
freight              CHAR (35), 
buyer                CHAR (35), 
comments_full        CHAR (105), 
attention            CHAR (35), 
default_key_orgn     CHAR (24), 
default_account      CHAR (8), 
user_id              CHAR (8), 
check_out_id         INT,
order_id             INT,
bb_user_id           INT,
bb_vendor_id         CHAR (25), 
shopper_name         CHAR (35), 
buyer_cookie         CHAR (80),
default_proj	   CHAR(8),
default_projacct     CHAR(8) 
);



CREATE TABLE dbo.interface_notify ( 
vendor_code          CHAR (12)            NOT NULL, 
location             CHAR (25)            NOT NULL, 
email_addr           CHAR (50)            NOT NULL, 
notify_name          CHAR (25), 
notify_code          CHAR (1)             NOT NULL 
)


CREATE TABLE dbo.web_admin_options (
prod_name       CHAR (24),
descript        CHAR (50), 
long_descript   CHAR (255),
opt_type        CHAR (5),
category        CHAR (24)
)



CREATE TABLE dbo.web_admin (
empl_no         INTEGER,
prod_name       CHAR (24),
descript        CHAR (50),
val             CHAR (255)
)