const w4 = @import("wasm4.zig");
const std = @import("std");

pub const Point = struct {
    x: i32,
    y: i32,
    pub fn init(x: i32, y: i32) @This() {
        return @This(){
            .x = x,
            .y = y,
        };
    }
    pub fn equals(this: @This(), other: @This()) bool {
        return this.x == other.x and this.y == other.y;
    }
};

pub const Snake = struct {
    body: std.BoundedArray(Point, 400),
    direction: Point,

    pub fn init() @This() {
        return @This(){
            .body = std.BoundedArray(Point, 400).fromSlice(&.{
                Point.init(2, 0),
                Point.init(1, 0),
                Point.init(0, 0),
            }) catch @panic("couldn't init snake body"),
            .direction = Point.init(1, 0),
        };
    }

    pub fn draw(this: @This()) void {
        w4.DRAW_COLORS.* = 0x0043;
        for (this.body.constSlice()) |part| {
            w4.rect(part.x * 8, part.y * 8, 8, 8);
        }

        w4.DRAW_COLORS.* = 0x0004;
        w4.rect(this.body.get(0).x * 8, this.body.get(0).y * 8, 8, 8);
    }

    pub fn update(this: *@This()) void {
        const part = this.body.slice();
        var i: usize = part.len - 1;
        while (i > 0) : (i -= 1) {
            part[i].x = part[i - 1].x;
            part[i].y = part[i - 1].y;
        }

        part[0].x = @mod((part[0].x + this.direction.x), 20);
        part[0].y = @mod((part[0].y + this.direction.y), 20);
    }

    pub fn down(this: *@This()) void {
        this.direction.x = 0;
        this.direction.y = 1;
    }

    pub fn up(this: *@This()) void {
        this.direction.x = 0;
        this.direction.y = -1;
    }

    pub fn left(this: *@This()) void {
        this.direction.x = -1;
        this.direction.y = 0;
    }

    pub fn right(this: *@This()) void {
        this.direction.x = 1;
        this.direction.y = 0;
    }

    pub fn isDead(this: @This()) bool {
        const head = this.body.get(0);
        for (this.body.constSlice()) |part, i| {
            if (i == 0) continue;
            if (part.equals(head)) return true;
        }
        return false;
    }
};

var snake: Snake = Snake.init();
var frame_count: u32 = 0;
var prev_state: u8 = 0;
var fruit: Point = undefined;
var prng: std.rand.DefaultPrng = undefined;
var random: std.rand.Random = undefined;

// fruit
const fruit_width = 8;
const fruit_height = 8;
const fruit_flags = w4.BLIT_2BPP;
const fruit_sprite = [16]u8{ 0x00, 0xa0, 0x02, 0x00, 0x0e, 0xf0, 0x36, 0x5c, 0xd6, 0x57, 0xd5, 0x57, 0x35, 0x5c, 0x0f, 0xf0 };

fn rnd(max: i32) i32 {
    return random.intRangeLessThan(i32, 0, max);
}

export fn start() void {
    w4.PALETTE.* = .{
        0xfbf7f3,
        0xe5b083,
        0x426e5d,
        0x20283d,
    };
    prng = std.rand.DefaultPrng.init(0);
    random = prng.random();
    fruit = Point.init(rnd(20), rnd(20));
}

fn input() void {
    const gamepad = w4.GAMEPAD1.*;
    const just_pressed = gamepad & (gamepad ^ prev_state);
    if (just_pressed & w4.BUTTON_LEFT != 0) snake.left();
    if (just_pressed & w4.BUTTON_RIGHT != 0) snake.right();
    if (just_pressed & w4.BUTTON_UP != 0) snake.up();
    if (just_pressed & w4.BUTTON_DOWN != 0) snake.down();
    prev_state = gamepad;
}

export fn update() void {
    frame_count += 1;
    input();
    if (frame_count % 15 == 0) {
        snake.update();

        if (snake.isDead()) { // Do something
            w4.trace("dead");
        }

        if (snake.body.get(0).equals(fruit)) { // Snake's head hits the fruit
            const tail = snake.body.get(snake.body.len - 1);
            snake.body.append(Point.init(tail.x, tail.y)) catch @panic("couldn't grow snake");
            fruit.x = rnd(20);
            fruit.y = rnd(20);
        }
    }
    snake.draw();

    w4.DRAW_COLORS.* = 0x4320;
    w4.blit(&fruit_sprite, fruit.x * 8, fruit.y * 8, fruit_width, fruit_height, fruit_flags);
}
