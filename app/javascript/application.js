// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "jquery";
import "custom/image_upload";
import "bootstrap";
import "@rails/ujs";
import "./custom/translations";
import Rails from "@rails/ujs";
Rails.start();
