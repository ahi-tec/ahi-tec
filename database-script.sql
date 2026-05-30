-- ============================================================
-- IT Equipment Management System - MySQL Database Script
-- Converted from SQL Server version
-- ============================================================

CREATE DATABASE IF NOT EXISTS `it_equipment_management`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `it_equipment_management`;

-- ============================================================
-- 1. Users
-- ============================================================
CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` VARCHAR(50) NOT NULL,
    `password_hash` VARCHAR(256) NOT NULL,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(200) NULL,
    `role` VARCHAR(50) NOT NULL DEFAULT 'User',
    `employee_id` INT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_login_date` DATETIME NULL,
    UNIQUE KEY `uk_users_user_id` (`user_id`)
) ENGINE=InnoDB;

-- ============================================================
-- 2. Departments
-- ============================================================
CREATE TABLE `departments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `department_code` VARCHAR(50) NOT NULL,
    `department_name` VARCHAR(200) NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_departments_code` (`department_code`)
) ENGINE=InnoDB;

-- ============================================================
-- 3. Item Categories
-- ============================================================
CREATE TABLE `item_categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_code` VARCHAR(50) NOT NULL,
    `category_name` VARCHAR(200) NOT NULL,
    `item_type` VARCHAR(20) NOT NULL,
    `description` VARCHAR(500) NULL,
    `require_checklist` TINYINT(1) NOT NULL DEFAULT 0,
    `require_maintenance` TINYINT(1) NOT NULL DEFAULT 0,
    `maintenance_frequency_days` INT NOT NULL DEFAULT 0,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    `updated_date` DATETIME NULL,
    `updated_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_item_categories_code` (`category_code`)
) ENGINE=InnoDB;

-- ============================================================
-- 4. Category Attributes
-- ============================================================
CREATE TABLE `category_attributes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NOT NULL,
    `attribute_name` VARCHAR(200) NOT NULL,
    `attribute_code` VARCHAR(100) NOT NULL,
    `data_type` VARCHAR(50) NOT NULL DEFAULT 'Text',
    `list_values` TEXT NULL,
    `is_required` TINYINT(1) NOT NULL DEFAULT 0,
    `display_order` INT NOT NULL DEFAULT 0,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_category_attributes_category` FOREIGN KEY (`category_id`) REFERENCES `item_categories`(`id`)
) ENGINE=InnoDB;

-- ============================================================
-- 5. Suppliers
-- ============================================================
CREATE TABLE `suppliers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `supplier_code` VARCHAR(50) NOT NULL,
    `supplier_name` VARCHAR(200) NOT NULL,
    `contact_person` VARCHAR(100) NULL,
    `phone` VARCHAR(50) NULL,
    `email` VARCHAR(200) NULL,
    `address` VARCHAR(500) NULL,
    `note` TEXT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    `updated_date` DATETIME NULL,
    `updated_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_suppliers_code` (`supplier_code`)
) ENGINE=InnoDB;

-- ============================================================
-- 6. Locations
-- ============================================================
CREATE TABLE `locations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `location_code` VARCHAR(50) NOT NULL,
    `location_name` VARCHAR(200) NOT NULL,
    `description` VARCHAR(500) NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    `updated_date` DATETIME NULL,
    `updated_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_locations_code` (`location_code`)
) ENGINE=InnoDB;

-- ============================================================
-- 7. Location Name History
-- ============================================================
CREATE TABLE `location_name_histories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `location_id` INT NOT NULL,
    `old_name` VARCHAR(200) NOT NULL,
    `new_name` VARCHAR(200) NOT NULL,
    `changed_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `changed_by` VARCHAR(100) NULL,
    CONSTRAINT `fk_location_name_histories_location` FOREIGN KEY (`location_id`) REFERENCES `locations`(`id`)
) ENGINE=InnoDB;

-- ============================================================
-- 8. Employees
-- ============================================================
CREATE TABLE `employees` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `employee_code` VARCHAR(50) NOT NULL,
    `employee_name` VARCHAR(100) NOT NULL,
    `department` VARCHAR(100) NULL,
    `email` VARCHAR(200) NULL,
    `phone` VARCHAR(50) NULL,
    `employee_type` VARCHAR(50) NULL,
    `user_id` INT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_employees_code` (`employee_code`)
) ENGINE=InnoDB;

-- ============================================================
-- 9. Equipment
-- ============================================================
CREATE TABLE `equipment` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `equipment_code` VARCHAR(50) NOT NULL,
    `equipment_name` VARCHAR(200) NOT NULL,
    `category_id` INT NOT NULL,
    `supplier_id` INT NULL,
    `location_id` INT NULL,
    `department_id` INT NULL,
    `installer_id` INT NULL,
    `checker_id` INT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'InStock',
    `previous_status` VARCHAR(50) NULL,
    `purchase_date` DATE NULL,
    `install_date` DATE NULL,
    `note` TEXT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    `updated_date` DATETIME NULL,
    `updated_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_equipment_code` (`equipment_code`),
    CONSTRAINT `fk_equipment_category` FOREIGN KEY (`category_id`) REFERENCES `item_categories`(`id`),
    CONSTRAINT `fk_equipment_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers`(`id`),
    CONSTRAINT `fk_equipment_location` FOREIGN KEY (`location_id`) REFERENCES `locations`(`id`),
    CONSTRAINT `fk_equipment_department` FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`),
    CONSTRAINT `fk_equipment_installer` FOREIGN KEY (`installer_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_equipment_checker` FOREIGN KEY (`checker_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 10. Equipment Attribute Values
-- ============================================================
CREATE TABLE `equipment_attribute_values` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `equipment_id` INT NOT NULL,
    `attribute_id` INT NOT NULL,
    `attribute_value` TEXT NULL,
    `updated_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_by` VARCHAR(100) NULL,
    CONSTRAINT `fk_equipment_attr_values_equip` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`),
    CONSTRAINT `fk_equipment_attr_values_attr` FOREIGN KEY (`attribute_id`) REFERENCES `category_attributes`(`id`)
) ENGINE=InnoDB;

-- ============================================================
-- 11. Equipment Name History
-- ============================================================
CREATE TABLE `equipment_name_histories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `equipment_id` INT NOT NULL,
    `old_name` VARCHAR(200) NOT NULL,
    `new_name` VARCHAR(200) NOT NULL,
    `changed_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `changed_by` VARCHAR(100) NULL,
    CONSTRAINT `fk_equipment_name_histories_equip` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`)
) ENGINE=InnoDB;

-- ============================================================
-- 12. Components
-- ============================================================
CREATE TABLE `components` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `component_code` VARCHAR(50) NOT NULL,
    `component_name` VARCHAR(200) NOT NULL,
    `category_id` INT NOT NULL,
    `supplier_id` INT NULL,
    `opening_stock` INT NOT NULL DEFAULT 0,
    `current_stock` INT NOT NULL DEFAULT 0,
    `safety_stock` INT NOT NULL DEFAULT 0,
    `unit` VARCHAR(50) NOT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'InStock',
    `purchase_date` DATE NULL,
    `note` TEXT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    `updated_date` DATETIME NULL,
    `updated_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_components_code` (`component_code`),
    CONSTRAINT `fk_components_category` FOREIGN KEY (`category_id`) REFERENCES `item_categories`(`id`),
    CONSTRAINT `fk_components_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers`(`id`)
) ENGINE=InnoDB;

-- ============================================================
-- 13. Component Attribute Values
-- ============================================================
CREATE TABLE `component_attribute_values` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `component_id` INT NOT NULL,
    `attribute_id` INT NOT NULL,
    `attribute_value` TEXT NULL,
    `updated_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_by` VARCHAR(100) NULL,
    CONSTRAINT `fk_component_attr_values_comp` FOREIGN KEY (`component_id`) REFERENCES `components`(`id`),
    CONSTRAINT `fk_component_attr_values_attr` FOREIGN KEY (`attribute_id`) REFERENCES `category_attributes`(`id`)
) ENGINE=InnoDB;

-- ============================================================
-- 14. Component Name History
-- ============================================================
CREATE TABLE `component_name_histories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `component_id` INT NOT NULL,
    `old_name` VARCHAR(200) NOT NULL,
    `new_name` VARCHAR(200) NOT NULL,
    `changed_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `changed_by` VARCHAR(100) NULL,
    CONSTRAINT `fk_component_name_histories_comp` FOREIGN KEY (`component_id`) REFERENCES `components`(`id`)
) ENGINE=InnoDB;

-- ============================================================
-- 15. Transactions (Stock In/Out)
-- ============================================================
CREATE TABLE `transactions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `transaction_code` VARCHAR(50) NOT NULL,
    `transaction_type` VARCHAR(20) NOT NULL,
    `transaction_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `component_id` INT NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `related_equipment_id` INT NULL,
    `document_ref` VARCHAR(200) NULL,
    `purchase_date` DATE NULL,
    `performed_by_id` INT NULL,
    `receiver_name` VARCHAR(200) NULL,
    `reason` VARCHAR(500) NULL,
    `note` TEXT NULL,
    `created_by` VARCHAR(100) NULL,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_transactions_code` (`transaction_code`),
    CONSTRAINT `fk_transactions_component` FOREIGN KEY (`component_id`) REFERENCES `components`(`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_transactions_equipment` FOREIGN KEY (`related_equipment_id`) REFERENCES `equipment`(`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_transactions_performed_by` FOREIGN KEY (`performed_by_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 16. Maintenance Schedules
-- ============================================================
CREATE TABLE `maintenance_schedules` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NULL,
    `equipment_id` INT NOT NULL,
    `schedule_name` VARCHAR(200) NOT NULL,
    `frequency_type` VARCHAR(20) NOT NULL DEFAULT 'Yearly',
    `frequency_days` INT NOT NULL DEFAULT 0,
    `last_maintenance_date` DATETIME NULL,
    `next_maintenance_date` DATETIME NOT NULL,
    `assigned_employee_id` INT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'Pending',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    CONSTRAINT `fk_maintenance_schedules_category` FOREIGN KEY (`category_id`) REFERENCES `item_categories`(`id`),
    CONSTRAINT `fk_maintenance_schedules_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`),
    CONSTRAINT `fk_maintenance_schedules_employee` FOREIGN KEY (`assigned_employee_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 17. Maintenance Tickets
-- ============================================================
CREATE TABLE `maintenance_tickets` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `ticket_code` VARCHAR(50) NOT NULL,
    `maintenance_type` VARCHAR(20) NOT NULL DEFAULT 'Planned',
    `equipment_id` INT NOT NULL,
    `schedule_id` INT NULL,
    `performed_by_id` INT NULL,
    `maintenance_date` DATETIME NOT NULL,
    `description` TEXT NULL,
    `result` TEXT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'Planned',
    `completed_date` DATETIME NULL,
    `note` TEXT NULL,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_maintenance_tickets_code` (`ticket_code`),
    CONSTRAINT `fk_maintenance_tickets_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`),
    CONSTRAINT `fk_maintenance_tickets_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `maintenance_schedules`(`id`),
    CONSTRAINT `fk_maintenance_tickets_employee` FOREIGN KEY (`performed_by_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 18. Repair Tickets
-- ============================================================
CREATE TABLE `repair_tickets` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `ticket_code` VARCHAR(50) NOT NULL,
    `equipment_id` INT NOT NULL,
    `assigned_employee_id` INT NULL,
    `report_date` DATETIME NOT NULL,
    `issue_description` TEXT NOT NULL,
    `repair_description` TEXT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'Reported',
    `completed_date` DATETIME NULL,
    `note` TEXT NULL,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_repair_tickets_code` (`ticket_code`),
    CONSTRAINT `fk_repair_tickets_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`),
    CONSTRAINT `fk_repair_tickets_employee` FOREIGN KEY (`assigned_employee_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 19. Checklist Master Items
-- ============================================================
CREATE TABLE `checklist_master_items` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `item_name` VARCHAR(200) NOT NULL,
    `item_code` VARCHAR(100) NOT NULL,
    `description` VARCHAR(500) NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `display_order` INT NOT NULL DEFAULT 0,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_checklist_master_items_code` (`item_code`)
) ENGINE=InnoDB;

-- ============================================================
-- 20. Category Checklist Mappings
-- ============================================================
CREATE TABLE `category_checklist_mappings` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NOT NULL,
    `checklist_item_id` INT NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT `fk_category_checklist_mappings_category` FOREIGN KEY (`category_id`) REFERENCES `item_categories`(`id`),
    CONSTRAINT `fk_category_checklist_mappings_item` FOREIGN KEY (`checklist_item_id`) REFERENCES `checklist_master_items`(`id`)
) ENGINE=InnoDB;

-- ============================================================
-- 21. Checklist Headers
-- ============================================================
CREATE TABLE `checklist_headers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `checklist_code` VARCHAR(50) NOT NULL,
    `equipment_id` INT NOT NULL,
    `install_date` DATETIME NOT NULL,
    `installer_id` INT NULL,
    `checker_id` INT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'Pending',
    `due_date` DATETIME NULL,
    `completed_date` DATETIME NULL,
    `email_notification` TINYINT(1) NOT NULL DEFAULT 0,
    `notify_email` VARCHAR(500) NULL,
    `note` TEXT NULL,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_checklist_headers_code` (`checklist_code`),
    CONSTRAINT `fk_checklist_headers_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`),
    CONSTRAINT `fk_checklist_headers_installer` FOREIGN KEY (`installer_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_checklist_headers_checker` FOREIGN KEY (`checker_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 22. Checklist Details
-- ============================================================
CREATE TABLE `checklist_details` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `checklist_header_id` INT NOT NULL,
    `checklist_item_id` INT NOT NULL,
    `status` VARCHAR(10) NULL,
    `note` TEXT NULL,
    `checked_date` DATETIME NULL,
    `checked_by` VARCHAR(100) NULL,
    CONSTRAINT `fk_checklist_details_header` FOREIGN KEY (`checklist_header_id`) REFERENCES `checklist_headers`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_checklist_details_item` FOREIGN KEY (`checklist_item_id`) REFERENCES `checklist_master_items`(`id`)
) ENGINE=InnoDB;

-- ============================================================
-- 23. Disposal Records
-- ============================================================
CREATE TABLE `disposal_records` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `disposal_code` VARCHAR(50) NOT NULL,
    `item_type` VARCHAR(20) NOT NULL,
    `equipment_id` INT NULL,
    `component_id` INT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `disposal_date` DATETIME NOT NULL,
    `reason` TEXT NULL,
    `approved_by_id` INT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'Pending',
    `note` TEXT NULL,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    UNIQUE KEY `uk_disposal_records_code` (`disposal_code`),
    CONSTRAINT `fk_disposal_records_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`),
    CONSTRAINT `fk_disposal_records_component` FOREIGN KEY (`component_id`) REFERENCES `components`(`id`),
    CONSTRAINT `fk_disposal_records_approved_by` FOREIGN KEY (`approved_by_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 24. Update Histories
-- ============================================================
CREATE TABLE `update_histories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `equipment_id` INT NOT NULL,
    `category_id` INT NULL,
    `update_period` VARCHAR(20) NOT NULL,
    `update_type` VARCHAR(100) NOT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'Pending',
    `completed_date` DATETIME NULL,
    `assigned_employee_id` INT NULL,
    `note` TEXT NULL,
    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` VARCHAR(100) NULL,
    CONSTRAINT `fk_update_histories_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`),
    CONSTRAINT `fk_update_histories_category` FOREIGN KEY (`category_id`) REFERENCES `item_categories`(`id`),
    CONSTRAINT `fk_update_histories_employee` FOREIGN KEY (`assigned_employee_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- 25. Email Settings
-- ============================================================
CREATE TABLE `email_settings` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `smtp_server` VARCHAR(200) NOT NULL,
    `smtp_port` INT NOT NULL DEFAULT 587,
    `smtp_username` VARCHAR(200) NULL,
    `smtp_password` VARCHAR(200) NULL,
    `from_email` VARCHAR(200) NULL,
    `from_name` VARCHAR(200) NULL,
    `enable_ssl` TINYINT(1) NOT NULL DEFAULT 1,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `updated_date` DATETIME NULL
) ENGINE=InnoDB;

-- ============================================================
-- 26. Notification Configs
-- ============================================================
CREATE TABLE `notification_configs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `notification_type` VARCHAR(100) NOT NULL,
    `display_name` VARCHAR(200) NULL,
    `is_enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `description` VARCHAR(500) NULL,
    `subject_template` VARCHAR(500) NULL,
    `recipient_emails` VARCHAR(1000) NULL,
    `send_frequency` VARCHAR(20) NOT NULL DEFAULT 'Daily',
    `send_time` VARCHAR(5) NOT NULL DEFAULT '07:00',
    `group_by_recipient` TINYINT(1) NOT NULL DEFAULT 1,
    `last_sent_date` DATETIME NULL
) ENGINE=InnoDB;

-- ============================================================
-- 27. Email Logs
-- ============================================================
CREATE TABLE `email_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `notification_type` VARCHAR(100) NOT NULL,
    `to_email` VARCHAR(500) NOT NULL,
    `subject` VARCHAR(500) NOT NULL,
    `body` TEXT NULL,
    `status` VARCHAR(50) NOT NULL,
    `error_message` TEXT NULL,
    `sent_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- FK: Users -> Employees
-- ============================================================
ALTER TABLE `users` ADD CONSTRAINT `fk_users_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees`(`id`) ON DELETE SET NULL;

-- ============================================================
-- SEED DATA
-- ============================================================

-- Default Admin User (password: Admin@123)
INSERT INTO `users` (`user_id`, `password_hash`, `full_name`, `email`, `role`, `is_active`, `created_date`)
VALUES ('admin', '$2y$12$bMIpoHPzJIBP7/qhOt3q8uXOnCswTLNhchZ6oNecVcQ2P.yHaBSq6', 'Administrator', 'admin@company.com', 'Admin', 1, '2024-01-01 00:00:00');

-- Notification Configs (9 types)
INSERT INTO `notification_configs` (`id`, `notification_type`, `display_name`, `is_enabled`, `description`, `subject_template`, `send_frequency`, `send_time`, `group_by_recipient`) VALUES
(1, 'MaintenanceDue', 'Maintenance Due', 1, 'Send alert when equipment is due for maintenance (within 7 days)', '[Cảnh báo] Có {count} thiết bị sắp đến hạn bảo dưỡng', 'Daily', '07:00', 1),
(2, 'MaintenanceOverdue', 'Maintenance Overdue', 1, 'Send alert when equipment maintenance is overdue', '[KHẨN CẤP] Có {count} thiết bị QUÁ HẠN bảo dưỡng', 'Daily', '07:00', 1),
(3, 'ChecklistOverdue', 'Checklist Overdue', 1, 'Send alert when Checklist is incomplete and overdue', '[Cảnh báo] Có {count} Checklist chưa hoàn thành', 'Daily', '07:00', 1),
(4, 'ChecklistAssigned', 'Checklist Assigned', 1, 'Send notification when assigned to inspect a Checklist', '[Checklist] Bạn được phân công kiểm tra - {code}', 'Immediate', '07:00', 0),
(5, 'MaintenanceAssigned', 'Maintenance Assigned', 1, 'Send notification when assigned maintenance tickets', '[Bảo dưỡng] Bạn được phân công {count} phiếu bảo dưỡng mới', 'Immediate', '07:00', 0),
(6, 'RepairAssigned', 'Repair Assigned', 1, 'Send notification when assigned a repair ticket', '[Sửa chữa] Phiếu {code} - Bạn được phân công', 'Immediate', '07:00', 0),
(7, 'UpdateDue', 'Update Due', 0, 'Send alert when periodic updates are due', '[Cảnh báo] Có {count} thiết bị đến hạn cập nhật', 'Daily', '07:00', 1),
(8, 'LowStock', 'Low Stock', 0, 'Alert when components are below safety stock level', '[Cảnh báo] Có {count} linh kiện dưới mức tồn kho an toàn', 'Daily', '07:00', 1),
(9, 'DisposalApproval', 'Disposal Approval', 1, 'Send notification when a disposal request needs approval', '[Disposal] Request {code} needs your approval', 'Immediate', '07:00', 0);
