output "frontend-lb" {
    value = join(":",tolist([google_compute_global_forwarding_rule.frontend-forwarding-rule.ip_address,"8080"]))
    description = "Frontend Loadbalancer"
}
output "checkout-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.checkout-internal-forwarding-rule.ip_address,"8989"]))
    description = "Checkout Loadbalancer"
}
output "productcatalog-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.productcatalog-internal-forwarding-rule.ip_address,"8994"]))
    description = "productcatalog Loadbalancer"
}
output "shipping-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.shipping-internal-forwarding-rule.ip_address,"8995"]))
    description = "shipping Loadbalancer"
}
output "currency-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.currency-internal-forwarding-rule.ip_address,"8996"]))
    description = "currency Loadbalancer"
}
output "payment-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.payment-internal-forwarding-rule.ip_address,"8992"]))
    description = "cart Loadbalancer"
}
output "email-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.email-internal-forwarding-rule.ip_address,"8993"]))
    description = "cart Loadbalancer"
}
output "cart-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.cart-internal-forwarding-rule.ip_address,"8997"]))
    description = "cart Loadbalancer"
}
output "ad-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.ad-internal-forwarding-rule.ip_address,"8990"]))
    description = "ad Loadbalancer"
}
output "recommend-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.recommend-internal-forwarding-rule.ip_address,"8991"]))
    description = "recommend Loadbalancer"
}
output "redis-lb" {
    value = join(":",tolist([google_compute_forwarding_rule.redis-internal-forwarding-rule.ip_address,"8998"]))
    description = "recommend Loadbalancer"
}
