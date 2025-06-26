// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import CartController from "controllers/cart_controller"
application.register("cart", CartController);

import CounterController from "controllers/counter_controller";
application.register("counter", CounterController);

import FlashController from "controllers/flash_controller";
application.register("flash", FlashController);

import OrderRowController from "controllers/order_row_controller";
application.register("order_row", OrderRowController);

import ChoicesController from "controllers/choices_controller";
application.register("choices", ChoicesController);
