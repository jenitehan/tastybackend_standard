<?php
/**
 * @file
 * Enables modules and site configuration for a Tasty Backend standard site installation.
 */

/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 *
 * Allows the profile to alter the site configuration form.
 */
function tastybackend_standard_form_install_configure_form_alter(&$form, $form_state) {
  // Pre-populate the site name with the server name.
  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
}

/**
 * Implements hook_form_FORM_ID_alter().
 * Alter the path of the 'Add term' link to point to our custom 'Add tags' context admin page.
 */
function tastybackend_standard_form_taxonomy_overview_terms_alter(&$form, &$form_state, $form_id) {
  // Make sure we only alter the link on our custom page.
  $item = menu_get_item();
  if ($item['path'] == 'admin/manage/categories/tags') {
    $form['#empty_text'] = t('No terms available. <a href="@link">Add term</a>.', array('@link' => url('admin/manage/categories/tags/add')));
  }
}

/**
 * Implements hook_field_group_info().
 */
function tastybackend_standard_field_group_info() {
  $export = array();
  
  $field_group = new stdClass();
  $field_group->disabled = FALSE;
  $field_group->api_version = 1;
  $field_group->identifier = 'group_main_content|node|article|form';
  $field_group->group_name = 'group_main_content';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'article';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Main Content',
    'weight' => '0',
    'children' => array(
      0 => 'title',
      1 => 'field_tags',
      2 => 'body',
    ),
    'format_type' => 'tab',
    'format_settings' => array(
      'formatter' => 'closed',
      'instance_settings' => array(
        'description' => '',
        'classes' => 'group-main-content field-group-tab',
        'required_fields' => 1,
      ),
    ),
  );
  $export['group_main_content|node|article|form'] = $field_group;
  
  $field_group = new stdClass();
  $field_group->disabled = FALSE;
  $field_group->api_version = 1;
  $field_group->identifier = 'group_images|node|article|form';
  $field_group->group_name = 'group_images';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'article';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Images',
    'weight' => '1',
    'children' => array(
      0 => 'field_image',
    ),
    'format_type' => 'tab',
    'format_settings' => array(
      'formatter' => 'closed',
      'instance_settings' => array(
        'description' => '',
        'classes' => 'group-images field-group-tab',
        'required_fields' => 1,
      ),
    ),
  );
  $export['group_images|node|article|form'] = $field_group;
  
  $field_group = new stdClass();
  $field_group->disabled = FALSE;
  $field_group->api_version = 1;
  $field_group->identifier = 'group_main_content|node|page|form';
  $field_group->group_name = 'group_main_content';
  $field_group->entity_type = 'node';
  $field_group->bundle = 'page';
  $field_group->mode = 'form';
  $field_group->parent_name = '';
  $field_group->data = array(
    'label' => 'Main Content',
    'weight' => '0',
    'children' => array(
      0 => 'title',
      1 => 'body',
    ),
    'format_type' => 'tab',
    'format_settings' => array(
      'formatter' => 'closed',
      'instance_settings' => array(
        'description' => '',
        'classes' => 'group-main-content field-group-tab',
        'required_fields' => 1,
      ),
    ),
  );
  $export['group_main_content|node|page|form'] = $field_group;
  
  return $export;
}

/**
* Implements hook_ctools_plugin_api().
*/
function tastybackend_standard_ctools_plugin_api($owner, $api) {
  if ($owner == 'field_group' && $api == 'field_group') {
    return array('version' => 1);
  }
  if ($owner == "page_manager" && $api == "pages_default") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_views_api().
 */
function tastybackend_standard_views_api() {
  return array("version" => "3.0");
}

/**
 * Implements hook_menu_link_alter().
 */
function tastybackend_standard_menu_link_alter(&$item) {
  // Add a description for this menu link, can't seem to set it in the page manager code.
  // Checking if it's empty first so if a user overrides this in the UI it won't revert back to this.
  if ($item['link_path'] == 'admin/manage/categories/tags' && empty($item['options']['attributes']['title'])) {
    $item['options']['attributes']['title'] = t('Manage all terms in the "Tags" vocabulary.');
  }
}

/**
 * Implements hook_action_info().
 * 
 * Add missing action to bulk activate users.
 */
function tastybackend_standard_action_info() {
  return array(
    'tastybackend_standard_activate_user_action' => array(
      'type' => 'user',
      'label' => t('Activate user'),
      'configurable' => FALSE,
      'triggers' => array('any'),
    ),
  );
}

/**
 * Action to activate a user.
 */
function tastybackend_standard_activate_user_action($user) {
  user_save($user, array('status' => '1'));
}