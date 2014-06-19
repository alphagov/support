require 'rails_helper'
require 'volatile_lock'
require 'redis_client'

describe VolatileLock do
  let(:redis) { RedisClient.instance.connection }

  def volatile_lock(key, expiration_time = 1.second)
    VolatileLock.new(key, expiration_time)
  end

  it "starts by deleting possibly stale locks created by the same host" do
    redis.set('foo', Socket.gethostname)
    assert volatile_lock('foo').obtained?
  end

  it "ensures only one lock is obtained per key across hosts" do
    allow(Socket).to receive(:gethostname).and_return('pluto')
    assert volatile_lock('foo').obtained?

    allow(Socket).to receive(:gethostname).and_return('mars')
    refute volatile_lock('foo').obtained?
  end

  it "allows multiple locks to be obtained if keys differ" do
    assert volatile_lock('foo').obtained?
    assert volatile_lock('bar').obtained?
  end

  it "allows expiration_time to be changed" do
    redis = double(get: nil, setnx: true)
    expect(redis).to receive(:expire).with('foo', 30.seconds).and_return(true)
    allow_any_instance_of(VolatileLock).to receive(:redis).and_return(redis)

    volatile_lock('foo', 30.seconds).obtained?
  end

  context "failing to set expiration time" do
    it "raises a FailedToSetExpiration" do
      redis = double(get: nil, setnx: true, del: true, expire: false)
      allow_any_instance_of(VolatileLock).to receive(:redis).and_return(redis)

      assert_raises(VolatileLock::FailedToSetExpiration) { volatile_lock('foo').obtained? }
    end

    it "deletes the persisted key" do
      redis = double(get: nil, setnx: true, expire: false)
      expect(redis).to receive(:del).with('foo')
      allow_any_instance_of(VolatileLock).to receive(:redis).and_return(redis)

      volatile_lock('foo').obtained? rescue VolatileLock::FailedToSetExpiration
    end
  end

  after do
    redis.del('foo', 'bar')
  end
end
